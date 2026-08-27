#!/usr/bin/env bash
# Report frames whose content does not fit, and nothing else.
#
#   ./check.sh            # compile twice, then report
#   ./check.sh demo       build demo.tex instead of slides.tex
#   ./check.sh --no-build # just re-read the existing log
#
# WHY THIS EXISTS
#
# The point of moving off Slidev was that an overflowing slide should announce
# itself instead of being silently shrunk to fit. TeX does announce it — as
# `Overfull \vbox (N pt too high)` — but it also emits one constant piece of
# noise that has to be filtered or the real signal drowns in it.
#
# Every frame that has a title reports:
#
#   Overfull \hbox (21.33955pt too wide)
#
# That is the template working as designed, not a fault. The frame title is a
# full-bleed colour band: a beamercolorbox of `wd=\paperwidth` set inside a
# context whose measure is \textwidth. It is meant to run past the text block
# to both paper edges, and TeX has no way to be told that is deliberate. An
# untitled frame does not report it, which is how it was pinned down.
#
# So: \vbox warnings are real and mean the slide is too tall. \hbox warnings at
# exactly 21.33955pt are the band. Any OTHER \hbox warning is real too — a line
# running past the right margin, usually an unbreakable string in a narrow
# step card.
set -u

cd "$(dirname "$0")"

# Which document. Default slides.tex; pass a bare name to build another —
# `./check.sh demo` for the filled-out sample.
DOC=slides
for a in "$@"; do case "$a" in -*) ;; *) DOC="${a%.tex}" ;; esac; done
# This theme has no full-bleed title band, so there is no constant to filter.
# The value is kept only so the reporting code below has something to match on;
# it will never fire. If you port this script to a theme that does have one,
# build an untitled frame and a titled one and take the difference.
BAND='__no_band__'

if [ "${1:-}" = "--clean" ]; then
  rm -f $DOC.aux $DOC.log $DOC.nav $DOC.out $DOC.snm $DOC.toc \
        $DOC.synctex.gz missfont.log $DOC.pdf
  find . -name .DS_Store -delete
  echo "cleaned"
  exit 0
fi

# xelatex or lualatex — both load fonts through fontspec. NOT pdflatex: the
# deck bundles Cormorant as OpenType and reaches it by path, which pdflatex
# cannot do, so ENGINE=pdflatex dies on the first \setmainfont. It used to
# work, before the font. xelatex is the default because it is what these files
# were verified with, and it is faster.
#
# The one measurable difference is microtype: under XeTeX only character
# protrusion is available, while LuaTeX also does font expansion. It matters
# less here than it sounds. The step cards are centred, and centred text has no
# justification to optimise, so expansion does nothing for them; the body
# paragraphs are justified but set at ~410pt, where protrusion alone already
# does most of the work.
#
# Override for a one-off:  ENGINE=lualatex ./check.sh
ENGINE="${ENGINE:-xelatex}"

if [ "${1:-}" != "--no-build" ]; then
  # Delete the previous PDF before building. Without this a failed build leaves
  # the last good one sitting there, and the failure looks like a success with
  # stale output — which is exactly the trap the missing-font check exists to
  # avoid.
  rm -f $DOC.pdf 2>/dev/null || true

  # -halt-on-error matters as much as the flag above. Under plain nonstopmode
  # LaTeX reports a \PackageError and then carries on to produce a PDF anyway,
  # so a missing bundled font would yield a document silently set in whatever
  # the fallback chain found. Stopping means no PDF rather than a wrong one.
  #
  # Twice: the footer's progress bar needs \inserttotalframenumber from the aux.
  for _ in 1 2; do
    if ! "$ENGINE" -interaction=nonstopmode -halt-on-error \
                   -file-line-error $DOC.tex >/dev/null 2>&1; then
      echo "BUILD FAILED — first error from the log:"
      echo
      grep -m1 -A6 -E '^(!|.*:[0-9]+:)' $DOC.log | sed 's/^/  /'
      exit 1
    fi
  done
fi

[ -f $DOC.log ] || { echo "no $DOC.log — compile first"; exit 1; }

echo "=== frames whose content is too tall ==="
if grep -q 'Overfull \\vbox' $DOC.log; then
  grep -n 'Overfull \\vbox' $DOC.log | sed 's/^/  /'
  echo
  echo "  Each of these is a slide with more on it than the frame holds."
  echo "  Cut it or split it. Do not reach for \\begin{frame}[shrink] — that"
  echo "  scales the content down to fit, which is the behaviour this deck"
  echo "  was moved off Slidev to get away from."
else
  echo "  none — every frame fits"
fi

echo
echo "=== lines running past the right margin ==="
REAL=$(grep 'Overfull \\hbox' $DOC.log | grep -v "$BAND" || true)
if [ -n "$REAL" ]; then
  echo "$REAL" | sed 's/^/  /'
else
  echo "  none"
fi

BANDS=$(grep -c "Overfull \\\\hbox ($BAND" $DOC.log || true)
if [ "$BANDS" -gt 0 ]; then
  echo
  echo "(suppressed $BANDS full-bleed frame-title warnings at $BAND — see the"
  echo " comment at the top of this script)"
fi
