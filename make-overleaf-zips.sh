#!/usr/bin/env bash
# Build one flat zip per template, for the "Open in Overleaf" buttons.
#
#   ./make-overleaf-zips.sh          # writes dist/*.zip
#
# WHY FLAT
#
# Overleaf's API unpacks the zip into a new project and compiles from the
# project root. Every template here reaches for its own files by relative path
# — \input{style}, figures/, fonts/, the .sty — so slides.tex has to land AT
# the root, not one level down. GitHub's own repository zip nests everything
# under beamer-templates-<branch>/, which is exactly the layout that fails.
#
# So each zip is made from inside the template directory: `cd slate-blocks &&
# zip -r ... .` rather than `zip -r ... slate-blocks`.
#
# WHERE THEY GO
#
# Attach them to a GitHub release. The buttons point at
#   .../releases/latest/download/<name>.zip
# which always resolves to the newest release, so the README does not need
# editing when you cut a new one. dist/ is gitignored: these are artefacts.
set -euo pipefail
cd "$(dirname "$0")"

rm -rf dist && mkdir -p dist

for d in */; do
  name=${d%/}
  [ -f "$name/slides.tex" ] || continue
  # `zip -r - .` writes the archive to stdout. Writing to a named file would
  # be the obvious thing, but zip builds a temporary beside it and renames,
  # which needs unlink; redirecting is a plain write and works anywhere.
  ( cd "$name" && zip -qr - . \
      -x '*.aux' '*.log' '*.nav' '*.out' '*.snm' '*.toc' '*.vrb' \
         '*.synctex.gz' '*.pdf' '*.DS_Store' 'check.sh' \
         'screenshots/*' ) > "dist/$name.zip"
  printf '%-20s %s\n' "$name.zip" "$(du -h "dist/$name.zip" | cut -f1)"
done

echo
echo "Attach dist/*.zip to a GitHub release; the README buttons point at"
echo "releases/latest/download/, so they pick up the newest one on their own."
