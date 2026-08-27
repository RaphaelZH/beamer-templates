# fonts/

Vendored, not installed, so the deck renders the same on any machine. It
previously depended on Lato being present; it was on one machine and not
another, and the template's fallback chain quietly substituted Helvetica
without reporting anything.

- `montserrat/` — Montserrat. Body text, and everything else that is read.
- `EBGaramond-0.016/` — Georg Duffner's EB Garamond, **release 0.016**.
  Titles, cover, section dividers. An old-style serif, chosen for the long
  fine tail on its Q.

## Only the faces this deck loads are here

Both directories are subsets of their upstream releases, which the OFL permits.
Montserrat ships eighteen weights and both outline formats; EB Garamond 0.016
ships two optical sizes, a separate small-caps family, three sets of decorated
initials and a specimen PDF. Together that was 63 files and 19 MB, of which the
template loaded six. It is now 12 files and 2.1 MB, and every screenshot in
`screenshots/` is pixel-identical to a build from the full release — which is
how the subset was checked, rather than by reading the code and hoping.

```
montserrat/            Regular  Italic  SemiBold  SemiBoldItalic     + OFL.txt
EBGaramond-0.016/otf/  EBGaramond12-Regular  EBGaramond12-Italic    + COPYING
```

`\bfseries` in the body resolves to SemiBold, not to Bold — a deliberate
setting in `tdstyle.tex`, not an accident of what is bundled. Montserrat Bold
and the rest of the range are one download away if a deck wants them:
<https://github.com/JulietaUla/Montserrat>.

`.otf` rather than `.ttf` throughout. Both carry the same feature table here,
but the OTF is the PostScript-outline original and is what the foundry treats
as canonical.

## The one thing that will bite you

**0.016 has no bold at all.** Regular and Italic, and nothing else — no bold,
no semibold, in any optical size. `tdstyle.tex` therefore maps `BoldFont` onto
`*-Regular` and sets the title fonts at `\mdseries` explicitly, so nothing ever
asks for a weight that does not exist and gets a synthesised one. That is a
position, not a workaround: `\bfseries` on a face with no bold makes fontspec
smear the outline, which on a Garamond looks like a printing fault, and an
old-style serif used for display was never bolded anyway.

The Google Fonts and Octavio Pardo releases of EB Garamond are a different
font: one optical size, weights 400–800, and a real bold. **Swapping one in
will not fail** — it will quietly change what every title looks like, and the
`\mdseries` settings will stop making sense. If you replace this directory,
re-read the DISPLAY FACE section of `tdstyle.tex` before trusting the render.

## Licences

Both families are under the SIL Open Font License 1.1 and are redistributed
unmodified. The licence text travels with the files — `montserrat/OFL.txt` and
`EBGaramond-0.016/COPYING` — and must keep doing so, including inside the zips
that `make-overleaf-zips.sh` builds. Taking a subset of a family is permitted;
dropping its licence is not. See this template's `LICENSE` for the whole
picture, the cover photograph and the theme included.
