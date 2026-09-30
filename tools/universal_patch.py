#!/usr/bin/env python3
"""Signature-based Samsung Android 14 smali patch merger.

The original project copied complete framework classes from one Samsung build.
This tool instead imports only the methods that contain one of the project's
helper calls, preserving all other fields/methods of the target framework.
"""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

METHOD_RE = re.compile(r'^\.method\s+.*?\s([^\s]+)\s*$')
CLASS_RE = re.compile(r'^\.class\s+.*?(L[^;]+;)\s*$')

RULES = [
    ("android/os/Build.smali", "android/os/Build.smali", "Landroid/os/BuildSpoof;"),
    ("android/os/SemSystemProperties.smali", "android/os/SemSystemProperties.smali", "Landroid/os/BuildSpoof;"),
    ("android/location/Country.smali", "android/location/Country.smali", "Landroid/location/Spoof;"),
    ("android/location/Location.smali", "android/location/Location.smali", "Landroid/location/Spoof;"),
    ("android/telephony/SubscriptionInfo.smali", "android/telephony/SubscriptionInfo.smali", "Landroid/location/Spoof;"),
    ("android/telephony/TelephonyManager.smali", "android/telephony/TelephonyManager.smali", "Landroid/location/Spoof;"),
]


def class_desc(text: str) -> str | None:
    m = CLASS_RE.search(text, re.M)
    return m.group(1) if m else None


def method_key(header: str) -> str:
    m = METHOD_RE.match(header.rstrip("\n"))
    if not m:
        raise ValueError(f"Cannot parse method declaration: {header!r}")
    return m.group(1)


def parse_methods(text: str):
    lines = text.splitlines(keepends=True)
    methods = []
    start = None
    header = None
    for i, line in enumerate(lines):
        if line.startswith('.method '):
            if start is not None:
                raise ValueError('Nested/unclosed .method encountered')
            start, header = i, line
        elif start is not None and line.strip() == '.end method':
            body = ''.join(lines[start:i + 1])
            methods.append((method_key(header), header, body))
            start = None
            header = None
    if start is not None:
        raise ValueError('Unclosed .method block')
    return methods


def find_class(root: Path, rel: str) -> Path | None:
    hits = list(root.glob(f"*/{rel}"))
    if not hits:
        return None
    if len(hits) > 1:
        # A disassembled DEX tree has one copy per DEX; a class descriptor must
        # be unique in a valid framework. Refuse ambiguity rather than patching
        # an arbitrary copy.
        raise RuntimeError(f"Class appears in multiple DEX directories: {rel}: {hits}")
    return hits[0]


def replace_methods(target_text: str, replacements: dict[str, str]):
    lines = target_text.splitlines(keepends=True)
    out = []
    i = 0
    applied = []
    while i < len(lines):
        if lines[i].startswith('.method '):
            header = lines[i]
            key = method_key(header)
            start = i
            i += 1
            while i < len(lines) and lines[i].strip() != '.end method':
                i += 1
            if i >= len(lines):
                raise ValueError(f"Unclosed method {key}")
            i += 1
            if key in replacements:
                # Preserve the patch method verbatim. This is deliberate: the
                # selected methods are small stable getters/bridges or the
                # Build property readers, while all unrelated target methods
                # remain byte-for-byte untouched at the smali level.
                out.append(replacements[key])
                if not replacements[key].endswith('\n'):
                    out.append('\n')
                applied.append(key)
            else:
                out.extend(lines[start:i])
        else:
            out.append(lines[i])
            i += 1
    return ''.join(out), applied


def patch_one(dex_root: Path, patch_root: Path, target_rel: str, marker: str):
    target = find_class(dex_root, target_rel)
    if target is None:
        return {"target": target_rel, "status": "missing-class", "methods": []}
    source = patch_root / target_rel
    if not source.is_file():
        raise RuntimeError(f"Missing patch source: {source}")

    src_text = source.read_text(encoding='utf-8')
    src_class = class_desc(src_text)
    tgt_text = target.read_text(encoding='utf-8')
    tgt_class = class_desc(tgt_text)
    if src_class != tgt_class:
        raise RuntimeError(f"Class mismatch for {target_rel}: source={src_class} target={tgt_class}")

    replacements = {}
    for key, _header, body in parse_methods(src_text):
        if marker in body:
            replacements[key] = body

    if not replacements:
        return {"target": target_rel, "status": "no-marker-methods", "methods": []}

    new_text, applied = replace_methods(tgt_text, replacements)
    missing = sorted(set(replacements) - set(applied))
    if applied:
        target.write_text(new_text, encoding='utf-8')
    return {
        "target": target_rel,
        "dex": target.relative_to(dex_root).parts[0],
        "status": "patched" if applied else "no-matching-methods",
        "methods": applied,
        "missing_methods": missing,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--dex-root', required=True, type=Path)
    ap.add_argument('--patch-root', required=True, type=Path)
    ap.add_argument('--report', type=Path)
    args = ap.parse_args()

    results = []
    for target_rel, patch_rel, marker in RULES:
        results.append(patch_one(args.dex_root, args.patch_root, target_rel, marker))

    # Build$VERSION is intentionally not copied wholesale. Its patch source
    # contains no project helper reference; copying it would reintroduce the
    # exact-build coupling this universal engine is designed to remove.
    summary = {
        "engine": "signature-method-v1",
        "results": results,
        "patched_methods": sum(len(r.get('methods', [])) for r in results),
    }
    if args.report:
        args.report.write_text(json.dumps(summary, indent=2), encoding='utf-8')
    print(json.dumps(summary, indent=2))


if __name__ == '__main__':
    main()
