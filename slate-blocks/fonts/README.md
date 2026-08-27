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
Cormorant/    Medium  Bold  MediumItalic  BoldItalic        + OFL.txt
              CormorantSC-Medium  CormorantSC-Bold            FONTLOG.txt
RedHatText/   Regular  Italic  Bold  BoldItalic            + OFL.txt
              Medium  MediumItalic
```

Each family has a full upright / italic / bold / bold-italic set, so nothing
here is ever synthesised. The rest of Cormorant — Light, Infant, Unicase,
Upright — is one download away if a deck wants it.

## The two things that will bite you

**Cormorant's small caps are a separate family, not an `smcp` feature.** So
`\textsc` finds nothing to switch to and sets ordinary lowercase — no error, no
warning. `\newcolouredblock` puts all seven block labels through `\textsc`, and
the frame titles go the same way, so getting this wrong costs the whole deck's
labels quietly. `SmallCapsFont` and `BoldFeatures = {SmallCapsFont = ...}` in
the `\setmainfont` call are what make them small caps at all. Check this on any
face you swap in: whether a family carries `smcp` or ships SC as separate files
is not something you can assume.

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
