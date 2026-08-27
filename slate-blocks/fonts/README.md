# fonts/

Vendored, not installed, so the deck renders the same on any machine. Loaded by
filename from `Path` — never by family name, which fontconfig resolves against
whatever happens to be on the machine and substitutes **silently** when it
finds nothing. A path that does not resolve is a build error; a family name
that does not resolve is a deck set in the wrong face.

- `RedHatText/` — Red Hat Text. Everything you read a paragraph of: body,
  bullets, block bodies, tables, the footline.
- `Cormorant/` — Cormorant. Everything you read one line of: the title page,
  frame titles, block labels, the section strip.

## Only the faces this deck loads are here

Both are subsets of their upstream releases, which the OFL permits. Cormorant
ships 30 files across six styles and five weights; Red Hat ships a Display
family beside the Text one, plus webfonts and TTFs.

```
Cormorant/    Medium  MediumItalic  Bold  BoldItalic        + OFL.txt
                                                              FONTLOG.txt
RedHatText/   Regular  Italic  Bold  BoldItalic            + OFL.txt
```

Each family has a full upright / italic / bold / bold-italic set, so nothing
here is ever synthesised. The rest of Cormorant — Light, Infant, Unicase,
Upright, and the separately drawn `CormorantSC` — is one download away if a
deck wants it.

## The two things that will bite you

**Small caps depend on which family the element resolves to, not on what you
declared.** Cormorant carries `smcp` in its upright faces, so `\textsc` works on
them unaided — but beamer resolves `frametitle` and `block title` through the
**sans** family, and until the `\setbeamerfont` block in `style.tex` says
otherwise those headings are set in whatever the sans slot holds. That is what
took all seven block labels the first time the fonts were swapped: they were
still being set in TeX Gyre Heros, which has no `smcp`.

`CormorantSC` was bundled for a while on the theory that `SmallCapsFont` was
what made those labels work. It was not. Removing both `SmallCapsFont` options
and deleting the two SC files changed **not one pixel** of any of the five
screenshots, which is how the claim was retired.

The real gap, read out of the `GSUB` tables rather than guessed: **Cormorant's
italics carry no `smcp`, and Red Hat Text carries none in any face.** `\textsc`
in body text, or inside italic display text, will set ordinary letters and say
nothing about it.

**Cormorant is a display face** — its own README says so. It is drawn for large
sizes and goes thin at body size, which is why it is not the body font here and
why even its display role uses Medium rather than Regular.

## Licences

Both families are under the SIL Open Font License 1.1 and are redistributed
unmodified. The licence text travels with the files — `Cormorant/OFL.txt` and
`RedHatText/OFL.txt` — and must keep doing so, including inside the zips that
`make-overleaf-zips.sh` builds. Taking a subset of a family is permitted;
dropping its licence is not.

Red Hat Text carries a **Reserved Font Name**: an altered copy may not be
distributed under the name "Red Hat". Shipping it as it is, which is what
happens here, is unrestricted. See this template's `LICENSE` for the whole
picture.
