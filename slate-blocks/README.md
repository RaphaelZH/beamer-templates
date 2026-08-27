# slate-blocks

A 16:10 beamer deck built on stock themes — Madrid, miniframes, circles — with
three things added: a palette derived from one colour, seven named blocks in
place of beamer's three, and a photographic title page.

The name is the palette, not the season. `#bec2cb` is a desaturated blue-grey;
the autumn cover is a photograph you are expected to swap out, and swapping it
changes nothing about the colours.

```
./check.sh          build slides.tex, report overflows
./check.sh demo     build demo.tex — every construct, filled
```

**XeLaTeX.** Two bundled faces with a division of labour, the same arrangement
`midcentury-olive/` uses:

| | |
|---|---|
| **Red Hat Text** | everything you read a paragraph of — body, bullets, block bodies, tables, the footline |
| **Cormorant** | everything you read one line of — the title page, frame titles, block labels, the section strip |

Both are under the SIL Open Font License, both are in `fonts/`, both are loaded
by filename from `Path`. Nothing to install and nothing that can be silently
substituted.

The split is not decoration. Cormorant is a display face — its own README says
so — and it is lovely at 21pt and thin at 9pt. Body text and the footline are
the two places a deck can least afford thin, so they go to Red Hat Text, which
was drawn for exactly that size. Cormorant Medium rather than Regular even in
its display role: against a Red Hat body, Regular reads as the quieter of the
two and the hierarchy inverts.

This template did build under pdfLaTeX until the fonts arrived. OpenType means
`fontspec` and `fontspec` means XeLaTeX, and that is the price. `check.sh`
already defaults to `xelatex`, so nothing about the workflow changes;
`ENGINE=pdflatex` now fails on the first `\setsansfont`.

## Before you build: the cover, and the logo

`figures/background.png` is the author's own photograph, edited into a
watercolour. It is used twice — full-bleed on the title page, and again at
6.7% as the watermark under every other slide. One line sets both:

```latex
\slateWatermark{figures/background.png}   % preamble, in slides.tex
\renewcommand{\slateBackground}{figures/background.png}   % if you want them different
```

Replace it and expect to re-measure the title page. Nothing on it is boxed —
the type sits on the photograph — so where each line lands was chosen from
where *this* picture is flat and pale, and a new one moves all of it. The
offsets and the two `!300` tints in `\slatetitlepage` carry the numbers they
were set from. Check the watermark too: 6.7% was set against an image of this
lightness, and a darker photograph at the same opacity will fight the body
text.

`figures/logo.png` is a placeholder. No institution's mark ships here — a logo
is its owner's trademark and the licence on these files does not extend to it.
Replace it locally and keep it out of the history.

## The palette is one colour

```latex
\definecolor{ThemeColor}{RGB}{190, 194, 203}   % #bec2cb
```

Everything else is derived from it by colour-wheel relations — two analogous,
three tetradic, two split-complementary — and all seven sit at the same
lightness and saturation. The hue distinguishes them and nothing else does, so
no block shouts louder than another.

The same colour does both ends of the range: at full strength it is a
background, and at `!250` — beamer's syntax for a tint past 100%, that is, a
darkening — it is the body text. That is what keeps the deck quiet.

To re-tint the whole deck, change the one `\definecolor` and re-derive the
other seven. They are not computed at build time; they are written out, because
`xcolor`'s wheel arithmetic does not survive being read back.

## Seven blocks

Beamer gives you `block`, `exampleblock`, `alertblock`. This wanted seven, each
naming what it holds:

```latex
\newcolouredblock{ExampleBox}   {Example}    {ThemeColor}
\newcolouredblock{CommentBox}   {Comment}    {AnalogousColor-1}
\newcolouredblock{ProposalBox}  {Proposal}   {AnalogousColor-2}
\newcolouredblock{ReminderBox}  {Reminder}   {TetradicColor-1}
\newcolouredblock{ProblemBox}   {Problem}    {TetradicColor-2}
\newcolouredblock{ChallengeBox} {Challenge}  {TetradicColor-3}
\newcolouredblock{DefinitionBox}{Definition} {SplitComplementaryColor-1}
```

The second argument is the printed label and nothing depends on it — rename
them into your own language there.

`\newcolouredblock` exists because beamer has no per-block colour.
`\setbeamercolor` inside a frame leaks into everything after it, so the factory
sets the colours before the environment and puts them back after, using
etoolbox's `\BeforeBeginEnvironment` / `\AfterEndEnvironment`. The original deck
wrote those eight lines out once per block, seven times over.

## The SWOT grid

```latex
\swot{strengths}{weaknesses}{opportunities}{threats}
```

A 3×3 `tcbitemize`: a blank corner, two column headers, two rows each opening
with a rotated label. The four quadrant colours are **mixed, not picked** —
every quadrant is half helpful/harmful and half internal/external — so both
axes are legible in the colour itself and a reader can place a quadrant without
reading a label. The letter watermarked in each quadrant is the tcolorbox
colour name, which labels it without spending a line on a heading.

Keep the contents short. Each quadrant gets a quarter of the slide and about
four lines is what fits; `./check.sh` will tell you when it does not.

The same command is in `midcentury-olive/`, in that template's colours.

## These stop the build

**`\newtheorem` on a name that already exists.** `\Example`, `\Definition` and
several others are taken — amsmath and beamer's own theorem set define them —
and `\newtheorem` fails outright. That is why every block name here carries a
`Box` suffix. It is uglier than the bare word and cheaper than finding out
which words are free in every package a future deck might load.

**A `\newcommand` with an argument inside a frame.** Beamer reads a frame body
twice, and the second read finds the definition already made:
`Illegal parameter number in definition of \beamer@doifinframe`. Define it in
the preamble.

## These render wrong and say nothing

**One pass.** Anything positioned with `remember picture, overlay` — which is
the whole title page, and the watermark — needs the previous pass's `.aux`. A
single `xelatex` leaves the cover blank and reports nothing. `check.sh` always
builds twice; if you build by hand, do the same.

**Two passes, on a clean tree.** Twice is enough to hold a settled layout, and
not enough to reach one. On a fresh clone, or on the first build after moving
anything on the title page, `check.sh` produces a title page with the
photograph out of position and the type missing — silently, with no warning in
the log. The third pass settles it, and every `check.sh` after that agrees to
the pixel. **Run `./check.sh demo` twice after you clone, and twice after any
change to `\slatetitlepage`.** This is why the committed screenshots look right
despite the trap: they were taken from an already-settled `.aux`.

**Small caps that are not small caps.** Cormorant ships its small caps as a
separate family, `CormorantSC`, rather than as an `smcp` feature inside the
roman. So `\textsc` finds nothing to switch to and sets ordinary lowercase
instead — no error, no warning, just a page that looks subtly wrong. It would
have taken every block label with it, because `\newcolouredblock` sets all
seven in `\textsc`, and the frame titles too. Naming `SmallCapsFont` and
`BoldFeatures = {SmallCapsFont = ...}` in the `\setmainfont` call is what makes
them small caps at all. Check this on any font you swap in: whether a family
carries `smcp` or ships SC as separate files is not something you can assume.

**A SWOT axis label that loses its second line.** The rotated labels in the
first column are `\parbox`es, three lines each: the axis name and a `\tiny`
parenthetical that wraps to two. Change the body font to a wider one and the
axis name wraps as well, making four lines in a column that holds three — and
the fourth does not overflow onto the page, it is simply **absent from the
render**, with nothing in the log naming it. "External origin" is a few points
longer than "Internal origin", so exactly one of the two labels loses its
subtitle and the page still looks plausible.

This has now happened twice: 2.4cm was enough for Computer Modern and broke
under TeX Gyre Heros; 2.5cm broke under Red Hat Text. It is at 2.7cm.
Measuring the string in a standalone document is not a reliable check — it
under-reported by enough to look safe at 2.5cm when it was not. **Change the
font, then look at the SWOT page.**

**A cover photograph that does not cover the page.** The deck is 16:10 and most
photographs are 16:9. `\includegraphics[width=\paperwidth]` scales the picture
to the paper's width and leaves it about a tenth of the page short — a white
band across the top that is easy to miss on a thumbnail. Giving both `width`
and `height` distorts the picture; adding `keepaspectratio` letterboxes it,
which is the same gap arrived at politely. `\slatecover` measures the image at
full width and scales by height instead when that is not tall enough, and the
node sits at `current page.center` so whichever dimension overruns is cropped
evenly by the page edge. Both the cover and the watermark go through it.

**A panel defending against a busyness that is not there.** There used to be a
double-stroked, shaded box behind the title, on the reasoning that a photograph
can be busy enough to swallow a plain panel. It can — but measure the ground
under the box before believing it does. Under the current cover the sky there
runs at sd 4.2 with no pixel darker than `(213,228,245)`, so the box was armour
against nothing, and its hard border was the loudest edge on the page.

There is no panel now. The type is set straight onto the photograph, placed
around the band of crowns rather than over it: title, author and affiliation
above it, the date on the field below it, the logo in the top-right corner.
Every line was checked against the darkest single pixel beneath it, and the
worst of them is 5.28:1.

**Those offsets are measurements of one photograph.** They are not a layout that
adapts. Replace `\slateBackground` and the first thing to do is find where the
new picture's flat ground is; the second is to re-check the two `!300` tints,
which exist because a specific patch of sky and a specific patch of field were
a specific brightness.

**The watermark at the wrong strength.** 6.7% reads as paper texture. At 15% it
reads as an image, and the body text has to fight it. It is one number in
`\slateWatermark`, and it is worth re-checking after you change the photograph.

**Cover opacity.** The photograph is laid down at `opacity=0.55`. At full
strength it comes up to the weight of the type over it; below about 0.5 it
stops looking held back and starts looking faded.

The usual recipe is two layers — the image at 0.65 with a white rectangle at
0.15 over it. It is not worth the second layer here. The page behind is white,
so the veil does nothing the opacity cannot, and the two render to within one
part in 255 of a single `opacity=0.5525`. That was measured by differencing the
two PNGs, not assumed. A white veil only earns its place over a ground that is
not already white.

## Noise in the log

The SWOT page reports one `Overfull \hbox` of about seven points. This README
used to call it a phantom of the raster, on the evidence that narrowing the
quadrant boxes at four different widths never moved it. That evidence was
sound and the conclusion was wrong: it is not the quadrants, it is the `\tiny`
parenthetical in the rotated axis label, which overruns the 71.1pt `\parbox`
it is set in. A number that does not move when you change one thing may still
be measuring another. It moves when you change the right thing: the same
warning changes with every change of face, because it is a piece of text that
is too wide for its box.

It is explained but not fixed, because the obvious fix trades it for a worse
warning. Widening that `\parbox` to 3.2cm silences the `\hbox` and produces an
`Overfull \vbox` of 16.5pt instead — the parbox is rotated, so its width is the
label's height, and the grid stops fitting the frame. The ceiling is about
2.62cm; the label wants 2.73cm. Closing the last three points means shorter
axis text, not a bigger box.

The report that matters is the first section, *frames whose content is too
tall*, and that one is exact.

## What is in `style.tex`

| | |
|---|---|
| the palette | one `\definecolor` and seven derivations, then the beamer colour assignments |
| `\newcolouredblock` | the block factory, and the seven it builds |
| `\slatecover{file}` | scales an image to cover the slide at any aspect ratio, without distorting it |
| `\slateWatermark` | the cover photograph on every slide at 6.7% |
| `\slatetitlepage` | full-bleed photograph, type set straight onto it — title block in the sky, date on the field, logo top-right |
| `\swot` | the 3×3 grid, its axis labels and its mixed quadrant colours |

Load it after `\documentclass` and the `\usetheme` lines. The five title-page
fields are `\renewcommand`s, not arguments, because a title page is the one
place a deck wants long strings with markup in them and five arguments to one
command is unreadable.
