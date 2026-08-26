# figures

`logo-trim.png` is **not** in this repository. Put your own institution's logo
here under that name — see the note at the top of ../README.md, including the
two measurements in `slides.tex` that have to be re-fitted for it.

`trim.py` crops the fully transparent border off a generated PNG, keeping 8px.
Run it after regenerating any chart. A bare `getbbox()` crop cuts to the ink,
which makes the figure effectively wider and taller inside the space it
occupies — enough to disturb a height that was tuned by eye.
