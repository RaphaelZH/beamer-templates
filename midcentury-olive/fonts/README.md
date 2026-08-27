# fonts/

Vendored, not installed, so the deck renders the same on any machine. It
previously depended on Lato being present; it was on one machine and not
another, and the template's fallback chain quietly substituted Helvetica
without reporting anything.

- `montserrat/` — Montserrat. Body text, and everything else that is read.
- `EBGaramond/` — the Duffner/Pardo EB Garamond. Titles, cover, section
  dividers. An old-style serif, chosen for the long fine tail on its Q.

## Only the faces this deck loads are here

Both directories are subsets of their upstream releases, which the OFL permits.
Montserrat ships eighteen weights in two outline formats; EB Garamond ships
five weights with matching italics, plus variable and web builds.

```
montserrat/       Regular  Italic  SemiBold  SemiBoldItalic       + OFL.txt
EBGaramond/otf/   Regular  Italic  Bold      BoldItalic           + OFL.txt
                                                                    AUTHORS.txt
```

Each family has a full upright / italic / bold / bold-italic set, so nothing is
ever synthesised. `\bfseries` in the body resolves to Montserrat SemiBold, not
Bold — a deliberate setting in `tdstyle.tex`, not an accident of what is here.

The subset is checked by rendering, not by reading: every screenshot in
`screenshots/` is rebuilt and compared after any change to this directory. If a
face the deck reaches for went missing, one of those nine pages would move.

`.otf` rather than `.ttf` throughout. Both carry the same feature table here,
but the OTF is the PostScript-outline original and is what the foundry treats
as canonical.

## Which EB Garamond — this matters more than it looks

There are two free fonts called EB Garamond and they are not the same font.

- **Duffner/Pardo `EBGaramond12`**, which is what is here. One optical size,
  weights 400–800, a real Bold and Bold Italic, `smcp` in every face.
- **Duffner 0.016**, which this used to carry. Two optical sizes (08 for small
  text, 12 for large), separate small-caps families, decorated initials — and
  **no bold in any of them**.

Swapping one for the other will not fail. It will quietly change what every
title looks like and what `\bfseries` resolves to.

### 0.016 looks like it has a bold. It does not.

This is worth writing down because it is convincing. Put 0.016's ten faces in a
file browser and the previews plainly differ in weight — `EBGaramond08` reads
much heavier than `EBGaramond12`. Measured, the difference is real: at a
matched cap height, 08's stem is **41% thicker** than 12's, which is the same
order as a genuine Medium-to-Bold step (Cormorant Medium→Bold is +40%).

It is still not a weight. It is an optical size — 08 is drawn to be set at 8pt,
where you need more ink. Two measurements tell them apart:

| | a real weight pair | 0.016's 12 → 08 |
|---|---|---|
| set width as it gets heavier | **wider** (+0.9% here, +2.7% Montserrat) | **narrower**, −1.5% |
| x-height ÷ cap-height | **constant** (Cormorant: 0.6176 both) | **shifts**, 0.631 → 0.616 |

So using 08 as a bold for 12 gives emphasis that is heavier, narrower and
differently proportioned — it reads as a different font, which is the one thing
emphasis must never do. Every face in 0.016 is `usWeightClass` 400 with the
bold bit clear and no variable-weight axis; there is no bold in that release
under any name.

## Licences

Both families are under the SIL Open Font License 1.1 and are redistributed
unmodified. Neither declares a Reserved Font Name. The licence text travels
with the files — `montserrat/OFL.txt` and `EBGaramond/OFL.txt` — and must keep
doing so, including inside the zips that `make-overleaf-zips.sh` builds. Taking
a subset of a family is permitted; dropping its licence is not.

Nothing else from either upstream is here. The OFL asks for the copyright
notice and the licence text, and both are inside `OFL.txt`. The one addition is
EB Garamond's `AUTHORS.txt`: its copyright line credits "The EB Garamond
Project Authors" rather than naming them, so the file that resolves who they
are is worth keeping beside it.

See this template's `LICENSE` for the whole picture, the cover photograph and
the theme included.
