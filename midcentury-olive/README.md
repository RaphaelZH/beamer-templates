# midcentury-olive

Extracted from *From Thing Descriptions to a Safety Ontology* (August 2026)
after that deck was finished. Copy this directory, replace `slides.tex`, keep
everything else.

Licensing is in [LICENSE](LICENSE): three different licences, because the theme,
the additions and the fonts came from three different places.

**XeLaTeX.** Two bundled faces with a division of labour, the same arrangement
`slate-blocks/` uses:

| | |
|---|---|
| **Montserrat** | everything you read a paragraph of — body, bullets, step cards, tables, the small print |
| **EB Garamond** | everything you read one line of — the cover, section dividers, frame titles |

Both are under the SIL Open Font License, both are in `fonts/`, both are loaded
by filename from `Path`. Nothing to install and nothing that can be silently
substituted. Only the four faces each deck loads are bundled; the details, and
what to re-check if you swap one, are in [`fonts/README.md`](fonts/README.md).

**The EB Garamond release changed.** This used to carry Duffner's 0.016, which
had two optical sizes and no bold in any of them; it now carries the
Duffner/Pardo `EBGaramond12` continuation, one optical size with weights 400 to
800. Titles are still set at `\mdseries` — that was always the design — but
`\bfseries` on the display face now resolves to a drawn Bold instead of quietly
resolving to Regular. If you rebuild an old deck against this directory, the
titles will not be identical to what you remember.

## Before you build: the logo

`figures/logo-trim.png` is a **placeholder** — a grey box reading YOUR LOGO
HERE. No institution's logo ships with this template: a mark is its owner's
trademark, a licence on the files around it does not extend to it, and a public
repository is not the place to redistribute one.

Drop your own in, then re-measure two things in `slides.tex`, both of which were
fitted to a particular logo and will be wrong for yours:

* `\titlegraphic{...height=1.5cm}` — the height;
* `\date{\makebox[2.413cm][l]{...}}` — the width that aligns the date's left
  edge to a feature of the logo above it. This is a fixed-width box rather than
  a nudge, because the date is set flush right: padding it would put its *left*
  edge wherever the string happened to end.

The placeholder is deliberately ugly. It builds, so a fresh clone works, and it
is impossible to leave in by accident.

## Attribution — required, not optional

The theme underneath is **midcentury modern** by **Jules Leguy**
(<https://github.com/jules-leguy/midcenturymodern>), used under **CC BY 4.0**.

That licence is not a courtesy. Distributing a modified version obliges you to
name the creator, give the source and the licence, and **indicate that changes
were made**. All four are in the header of `beamerthememidcenturymodern.sty` and
at the top of `tdstyle.tex`, where the changes are listed.

Two consequences worth being clear about:

* **Renaming the file would not remove the obligation — it would sharpen it.**
  The more the origin is obscured, the more the attribution has to be explicit.
* Keep it in the source files, not only here. A `.sty` gets copied into a new
  project on its own; a README does not travel with it.

`beamerthememidcenturymodern.sty` is upstream verbatim apart from six comment
lines in its header. Every addition lives in `tdstyle.tex`, so the theme can be
re-downloaded and dropped in without losing anything.

## Why the file is still called that

`mcm` — the prefix on `mcmPrimary`, `mcmBg`, `mcmBlack` and the rest — stands
for *mid-century modern*, the name of the theme this is built on. It is someone
else's word and it means nothing here, so **nothing in your slide source needs
to type it**: `tdstyle.tex` defines `oliveGreen`, `oliveInk` and `olivePaper`, and
the skeleton uses only those.

They are aliases, not renames, and deliberately so. The `.sty` refers to `mcm*`
throughout; renaming inside it would mean giving up the ability to drop in a new
upstream release, in exchange for tidying a prefix that then appears in nothing
but a file nobody edits. If you ever do decide to fork it properly, rename the
file *and* keep the attribution — see above.

```
./check.sh          build twice, report only real overflows
./check.sh --clean  remove build artefacts
```

---

## Build it twice. Always.

`./check.sh` does. A single `xelatex` run leaves the section dividers and study
dividers **blank** — they are drawn with `remember picture, overlay`, whose
coordinates come from the previous pass's `.aux`. This bit us: three pages
rendered as bare text with no background, and the cause was a one-pass build
left over from a measurement loop.

XeLaTeX, not LuaLaTeX. LuaLaTeX is unusable in the container we build in
(`module 'luaotfload-main' not found`; `texlive-luatex` is absent).

---

## These stop the build

**`\newcommand` with an argument, inside a frame.** Beamer reads a frame body
more than once. You get `Illegal parameter number in definition of
\beamer@doifinframe`, or `already defined` on the second pass. Cost us two
builds, once for a table column prefix and once for a bulleted-note command.
**Every command with an argument goes in the preamble.**

**`l` columns in a `tabular` with cells that need to wrap.** `l` cannot break a
line; one table ran 212pt — over 7cm — past the right margin. Use `p{}`, and
prefix with `>{\raggedright\arraybackslash}` unless you want justification.

---

## These render wrong and say nothing

**A second `\title`.** It silently overwrites the first, including any `\\` in
it. Declare it once.

**`\par` written outside a size group.** LaTeX sets a whole paragraph with the
`\baselineskip` in force when the paragraph *ends*. `{\scriptsize #1}\par`
therefore leads the text at the outer size — in `\stepcard` this made the card
bodies 40% too open, and only on the lines the size change was meant to cover.
Write `{\scriptsize #1\par}`.

**A hardcoded size inside a semantic command.** `\code` used to carry
`\footnotesize`. Inside a figure set at 6.6pt every literal became the largest
thing on the line. It now scales from the ambient size (`\tdCodeScale`) and
forces `\upshape`, because monospace slanted by a surrounding `\itshape` stops
reading as code.

**Fonts loaded by family name.** `smcp` is present only when the face is loaded
**by filename**; by fontconfig family name the feature silently does not apply.
And a font that is not installed is silently substituted — an early draft ran in
Helvetica on a machine without Lato and looked merely "a bit off". Everything is
bundled under `fonts/` and loaded by path for exactly this reason.

**Small caps in an element you did not put on the display face.** Loading the
face correctly is only half of it. Beamer resolves `frametitle` through the
sans family, so a frame title is set in Montserrat — not in Garamond — until
`\setbeamerfont` says otherwise, and `Letters = SmallCaps` on a family that has
no `smcp` gives ordinary letters with no warning. Both families here carry
`smcp` in every bundled face, so this template is safe as it stands;
`slate-blocks/` lost all seven of its block labels to exactly this and took two
attempts to diagnose. If you point an element at a new face, check both halves.

**`align=` inside a TikZ node.** It installs its own paragraph settings and
overrides `\raggedright` and `\hyphenpenalty` set in the node text. Use
`align=flush left` for ragged right, and `\hyphenchar\font=-1` — a font
property, which `align=` cannot override — to stop hyphenation.

**`columns[T]` with a listing in one column.** `[T]` aligns on the top of each
column's first box, so the listing's `aboveskip` pushes the code down. Zero it
and then *measure*: at `\scriptsize` against `\small` prose, about 5pt puts the
two first lines level. Open each column with `\vspace{0pt}` — that is the `[T]`
reference. `\strut\vspace{-\baselineskip}` is **not**: it prints line one on top
of line two.

**`\aside` on a full page.** Its `\vfill` has nothing left to push with, so the
rule lands against the last line of prose. It carries a `0.9em minus 0.85em`
floor: a gap when there is room, collapsible when there is not. A *rigid* floor
put two already-fitting frames back over the edge.

---

## Noise in the log, verified and filtered

**`Overfull \hbox (21.33955pt too wide)`, once per titled frame.** The frame
title is a full-bleed colour band — a `beamercolorbox` of `wd=\paperwidth` set
in a context whose measure is `\textwidth`. It is meant to run to both paper
edges. An untitled frame does not report it, which is how it was pinned down.
`check.sh` counts these and suppresses them; any *other* `\hbox` warning is real.

**Small constant `Overfull \vbox` on template-drawn `[plain]` pages.** The title
page and the section dividers report values like `7.1597pt` and `3.77133pt` that
respond to nothing — not to the section title's length, not to the logo height,
not to deleting the frame before them. Both pages were rendered at 130dpi and
read: nothing is clipped. They are the templates measuring their own
absolutely-positioned overlay, which contributes no height to the page. **Do not
chase these.** Roughly an hour went into one of them before that was established.

**The SWOT page's `Overfull \hbox` is gone, and it was not a phantom.** This
section used to file the `12.3812pt` here — and the `6.03252pt` in
`slate-blocks/` — beside the two above, on the evidence that it did not move
when the quadrant boxes were narrowed (5, 6, 7 and 8 mm of inset), when
`raster width` was set explicitly, or when the raster's skips were zeroed. All
of that was true, and the conclusion drawn from it was wrong.

It was the rotated axis label in the first column, too wide for the `\parbox`
it is set in — which is neither the quadrants nor the raster, so of course
none of those tests moved it. **A number that does not move when you change one
thing may still be measuring another.** The `\parbox` went from 2.4cm to 2.7cm
and the log is clean.

The fix is not the same in both templates, which is worth knowing before
copying one into the other. Here, widening the box is enough. In
`slate-blocks/` it is not: that deck is 16:10 with less vertical room, the
rotated `\parbox`'s width is the label's height, and widening it far enough
produces an `Overfull \vbox` before it silences the `\hbox`. There the note is
set a point smaller instead. Same cause, same page, two different levers.

---

## What is in `tdstyle.tex`

| | |
|---|---|
| `\oliveTheme` | the palette. Type `oliveGreen` (accent), `oliveInk` (text), `olivePaper` (ground), `oliveRust` (alert), `oliveTeal` (example) |
| `\ac{...}` | a term, in accent colour |
| `\acb{...}` | a named thing — a standard, a tool, a study — accent and bold |
| `\code{...}` | a literal. Follows the ambient size, always upright |
| `\aside{...}` | the note at the foot of a frame, above a hairline rule |
| `\slidelead{...}` | a frame's opening line, under the title band |
| `stepflow` / `\stepcard` / `\steparrow` | the card row. `\stepcard[w]` takes a width multiplier; the multipliers in a row should sum to the card count |
| `\tdsection{title}{subtitle}` | a section divider. **Takes both at once** — `\AtBeginSection` typesets the divider the moment `\section` runs, so a subtitle set on the following line arrives too late and is dropped |
| `\tdstudy{label}{title}{body}` | a divider *inside* a section. Quieter than a section page: thin spine, no page-wide fill |
| `\swot{S}{W}{O}{T}` | the 3×3 grid. Quadrant colours are *mixed* from the two axes rather than picked, so both axes are legible in the colour itself. Requires `\usepackage{tcolorbox}` and `\tcbuselibrary{skins, raster}` in the preamble. Keep each quadrant to about four lines |

`figures/trim.py` crops a transparent border off a generated PNG, keeping 8px.
A bare `getbbox()` crop makes the figure effectively wider and taller inside the
space it occupies, which is enough to disturb a height tuned by eye.

---

## Conventions the deck was written to

Not enforced by the machinery, but the pages assume them.

**Dividers.** Title states the section's claim or scope; subtitle names the
evidence. A subtitle that restates the title, or that announces the finding the
pages have to earn, leaves those pages with nothing to deliver. Three of the
five were rewritten for exactly this.

**Citations.** `\acb{Name et al., YYYY}` in prose, every time it appears — a rule
keyed to "first mention in a frame" has to be re-checked on every edit and rots
silently when a page moves. `\textbf{}` inside tables (that is the first-column
label style) and for paragraph leads that are not names.

**Cards and prose.** The cards carry the mechanics; the prose carries the
argument. Restating a card in the paragraph under it is the commonest way these
pages run over — it happened on four of them.

**Figures.** Draw only what the data says. An edge added to carry a caption is a
claim; a caption naming a value that is not in the picture points at nothing.
Both mistakes were made and caught: an invented `rotate → basic_sc` edge, and
two captions turning on `safe` and `nosec`, neither of which was drawn.

**Overflow.** When a page runs over, find what actually sets its height — the
tallest card in a row, the taller of two columns, a wrapped row *label*.
Shrinking anything else is wasted effort. Cut a sentence before you cut the gaps
between paragraphs: the gaps are what mark where one point ends.
