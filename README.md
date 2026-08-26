# Beamer templates

Presentation templates, one directory each, kept because each one was carried
through a real deck rather than admired on a gallery page. The point of the
collection is to have something to choose between.

Each directory stands alone: its own `slides.tex`, its own fonts, its own
`check.sh`, its own `README.md`, **its own `LICENSE`**. Copy one, do not try to
combine two.

## What is here

| | | |
|---|---|---|
| [`midcentury-olive/`](midcentury-olive/) | XeLaTeX · EB Garamond + Montserrat · olive green | A quiet, typographic 16:9 deck. Small-caps frame titles on a full-bleed band, card rows, section dividers with a subtitle. Built for a 45-page proposal defence. |

## What every template here has to do

These are the rules the collection is kept to. A template that cannot meet them
is not worth the trouble of keeping.

**Report, never shrink.** If a slide holds more than the frame does, the build
says so and names the frame. It does not scale the content down to fit — that is
the behaviour these were written to get away from, because it silently produces
a deck whose type size changes from page to page.

**Build with one command, twice.** `./check.sh`. Two passes, always: anything
positioned with `remember picture` needs the previous pass's `.aux`, and a
one-pass build leaves those pages blank without complaining.

**Bundle the fonts, load them by filename.** A font that is not installed is
substituted in silence, and a deck that looked fine on one machine is set in
Helvetica on another. Loading by fontconfig family name also loses OpenType
features — `smcp` in particular — with no warning.

**Carry its own licence, and its upstream's.** Most of these start from someone
else's theme. The obligation travels with the files, so the licence lives in the
template directory, not only here.

**Write down what went wrong.** Each `README.md` has a section of traps that
cost a build or a wrong render, with the symptom, not just the fix. That section
is the most valuable part of the directory and the reason to keep it rather than
start again.

## No logos

None of these ships an institution's logo. A mark is its owner's trademark and a
licence on the surrounding files does not extend to it. Each template has a
placeholder; each `README.md` says what to re-measure after you replace it.

## Licences

They differ per template, because the themes underneath come from different
places. See the `LICENSE` inside each directory. The fonts carry their own, in
`fonts/`, and are redistributed unmodified.
