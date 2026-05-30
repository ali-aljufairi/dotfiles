#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME}"
WRITE=false
DELETE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --write)
      WRITE=true
      shift
      ;;
    --delete)
      DELETE=true
      shift
      ;;
    -h|--help)
      cat <<'EOF'
Usage: ./bootstrap/sync-home.sh [--write] [--delete]

Without --write, runs in dry-run preview mode.
With --write, syncs repo home/ into $HOME.
With --delete, also removes files from $HOME that no longer exist in the repo.
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if command -v rsync >/dev/null 2>&1; then
  RSYNC_FLAGS=(-avh --itemize-changes)
  if [[ "$WRITE" == false ]]; then
    RSYNC_FLAGS+=(--dry-run)
  fi
  if [[ "$DELETE" == true ]]; then
    RSYNC_FLAGS+=(--delete)
  fi

  mkdir -p "$HOME_DIR/.config" "$HOME_DIR/.local/bin"

  rsync "${RSYNC_FLAGS[@]}" "$REPO_DIR/home/.config/" "$HOME_DIR/.config/"
  rsync "${RSYNC_FLAGS[@]}" "$REPO_DIR/home/.local/bin/" "$HOME_DIR/.local/bin/"

  if [[ -f "$REPO_DIR/home/.bashrc" ]]; then
    rsync "${RSYNC_FLAGS[@]}" "$REPO_DIR/home/.bashrc" "$HOME_DIR/.bashrc"
  fi

  if [[ -f "$REPO_DIR/home/.gitconfig" ]]; then
    rsync "${RSYNC_FLAGS[@]}" "$REPO_DIR/home/.gitconfig" "$HOME_DIR/.gitconfig"
  fi
else
  export NEXOS_REPO_DIR="$REPO_DIR"
  export NEXOS_HOME_DIR="$HOME_DIR"
  export NEXOS_WRITE="$WRITE"
  export NEXOS_DELETE="$DELETE"

  python3 <<'PY'
from pathlib import Path
from shutil import copy2
import os

repo = Path(os.environ['NEXOS_REPO_DIR'])
home = Path(os.environ['NEXOS_HOME_DIR'])
write = os.environ['NEXOS_WRITE'].lower() == 'true'
delete = os.environ['NEXOS_DELETE'].lower() == 'true'

pairs = [
    (repo / 'home/.config', home / '.config', True),
    (repo / 'home/.local/bin', home / '.local/bin', True),
    (repo / 'home/.bashrc', home / '.bashrc', False),
    (repo / 'home/.gitconfig', home / '.gitconfig', False),
]

changes = []

def file_changed(src: Path, dst: Path) -> bool:
    if not dst.exists():
        return True
    if src.stat().st_size != dst.stat().st_size:
        return True
    return src.read_bytes() != dst.read_bytes()

for src, dst, is_dir in pairs:
    if not src.exists():
        continue
    if is_dir:
        dst.mkdir(parents=True, exist_ok=True)
        src_entries = set()
        for path in src.rglob('*'):
            rel = path.relative_to(src)
            src_entries.add(rel)
            target = dst / rel
            if path.is_dir():
                if not target.exists():
                    changes.append(f"mkdir {target}")
                    if write:
                        target.mkdir(parents=True, exist_ok=True)
            else:
                if file_changed(path, target):
                    changes.append(f"copy  {target}")
                    if write:
                        target.parent.mkdir(parents=True, exist_ok=True)
                        copy2(path, target)
        if delete and dst.exists():
            existing = sorted(dst.rglob('*'), reverse=True)
            for path in existing:
                rel = path.relative_to(dst)
                if rel not in src_entries:
                    changes.append(f"delete {path}")
                    if write:
                        if path.is_dir():
                            try:
                                path.rmdir()
                            except OSError:
                                pass
                        else:
                            path.unlink(missing_ok=True)
    else:
        if file_changed(src, dst):
            changes.append(f"copy  {dst}")
            if write:
                dst.parent.mkdir(parents=True, exist_ok=True)
                copy2(src, dst)

if changes:
    print('\n'.join(changes))
else:
    print('No changes.')

if not write:
    print('\nDry run only. Re-run with --write to apply changes.')
else:
    print(f'\nDotfiles synced from {repo / "home"} to {home}')
PY
fi
