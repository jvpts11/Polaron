# 20. The mark, the colour and the icon

Polaron's visual identity, written down so that anything made for the language — a plugin, a docs
site, a conference slide, an editor theme — can be made to match without asking.

The assets themselves live in [`branding/`](../../../branding) in the compiler's repository:
`logo.svg`, `logo-light.svg`, `icon.svg`, `file-icon.svg`, `file-icon-light.svg`, `icon-128.png`,
`icon.ico`, `file-icon.ico`.

---

## 20.1 The mark is a lattice with one thing wrong with it

<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" width="128" height="128" role="img" aria-label="The Polaron mark">
  <g fill="#5a80ec">
    <circle cx="23.1" cy="23.1" r="3.1"/><circle cx="40.9" cy="23.1" r="3.1"/>
    <circle cx="23.1" cy="40.9" r="3.1"/><circle cx="40.9" cy="40.9" r="3.1"/>
    <circle cx="32" cy="11" r="2.3"/><circle cx="32" cy="53" r="2.3"/>
    <circle cx="11" cy="32" r="2.3"/><circle cx="53" cy="32" r="2.3"/>
  </g>
  <circle cx="32" cy="32" r="7" fill="#8ea6f2"/>
</svg>

A **polaron** is a real object in physics: a charge carrier moving through a crystal lattice,
dragging with it the distortion it causes. Carrier and cloud, treated as one thing.

So the mark is nine points — a heavy core, four near neighbours pulled **in** toward it on the
diagonals, and four further out on the axes still where the lattice put them. Near bends, far does
not, and the displacement is read from that rhythm rather than from any before-and-after.

**The rings are told apart by size, never by opacity.** A mark that leans on transparency dies the
first time it is punched into an `.ico`, stencilled into one colour, or printed.

## 20.2 The colours

| Role | Hex | Where |
|---|---|---|
| **Brand blue** | `#395fdb` | The solid tile the app icon is knocked out of. The one colour to use if you use only one. |
| Lattice | `#5a80ec` | The eight outer points on a dark ground. |
| Core | `#8ea6f2` | The centre point on a dark ground. |
| Lattice, on the tile | `#c9d6fb` | The points when the ground is brand blue. |
| Wordmark | `#e8ebf7` | `POLARON`, on dark. |
| Deep | `#1f3591` | Shadow and the darker half of a gradient. |
| Ground | `#13172a` | The dark background the dark-ground variants are drawn for. |
| Muted | `#5b6480`, `#5f688c` | Secondary strokes and disabled states. |

A saturated tile with the mark opened out of it is the version that gets **found** — an app icon
spends its life at 32 pixels next to a wall of other icons, and the dark tile that looked considered
on a page vanished into a dark taskbar.

## 20.3 The wordmark

`POLARON`, in Segoe UI Variable Display (or the platform's nearest humanist sans), **700 weight, 7
units of letter-spacing**, in `#e8ebf7` on dark or `#13172a` on light. The mark sits to its left at
the cap height of the type.

Never set the wordmark in a decorative face, and never letter-space it differently in two places: the
spacing is most of what makes it recognisable at a glance.

## 20.4 The file icon

`.pol` files get their own icon — the mark on a document silhouette rather than on a tile — so that a
folder of sources reads as Polaron at a glance without every file looking like the application.

## 20.5 The assets are generated, not drawn

The `.ico` and `.png` files are produced from the geometry by a generator **written in Polaron**
([`polaron-branding`](https://github.com/jvpts11/polaron-branding)): change `src/Mark.pol`, run it,
and every raster follows.

That is not a flourish. The icons used to be made by hand, so nothing connected them to the `.svg`
files beside them — and when the old mascot was removed from all five vectors it would have stayed
alive inside the icons the installer ships and the marketplace shows, with no build step failing and
nothing on screen to say so. A generator cannot drift.

> **On the previous identity.** Polaron was called LDP3 and carried an amber flame called Flamo.
> Both are retired. Anything still amber is either old or is using the colour for its own reasons —
> the border of a claimed territory in a game, say, where amber is chosen because it is the one
> colour a green-and-blue world does not contain.
