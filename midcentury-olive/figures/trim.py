# ladder.png -> ladder-trim.png : drop the transparent border, keep 8px of it.
#
# The chart is placed by width, so transparent padding shrinks the drawing
# inside the space it occupies. A bare getbbox() crop cuts to the ink and makes
# the figure 16px wider and taller in effect, which is enough to disturb a
# height that was tuned by eye against the query listing beside it. MARGIN
# reproduces the crop the deck was laid out against: 2451x1376 -> 2399x1113.
#
# Re-run after every ladder.py run.
from PIL import Image
MARGIN = 8
im = Image.open("ladder.png")
l, t, r, b = im.getbbox()
out = im.crop((l - MARGIN, t - MARGIN, r + MARGIN, b + MARGIN))
out.save("ladder-trim.png")
print("ladder-trim.png", out.size)
