# fonts/

Vendored, not installed, so the deck renders the same on any machine. It
previously depended on Lato being present; it was on one machine and not
another, and the template's fallback chain quietly substituted Helvetica
without reporting anything.

- `montserrat/` — Montserrat, full family, OTF + TTF. Body text.
- `EBGaramond-0.016/` — Georg Duffner's EB Garamond, **release 0.016**.
  Titles, cover, section dividers. An old-style serif, chosen for the long
  fine tail on its Q.

## The one thing that will bite you

**0.016 has no bold.** Regular and Italic only, in two optical sizes (08 for
small text, 12 for large). `tdstyle.tex` therefore sets the title fonts at
`\mdseries` explicitly, so nothing asks for a weight that does not exist and
gets a synthesised one instead.

The Google Fonts release of EB Garamond is a different font: one optical size,
weights 400–800. **Swapping it in will not fail** — it will quietly change what
the titles look like, and the `\mdseries` settings will stop making sense. If
you replace this directory, re-read the DISPLAY FACE section of `tdstyle.tex`.
