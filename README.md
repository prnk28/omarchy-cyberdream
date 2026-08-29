# Cyberdream for Omarchy

High-contrast neon dark theme for [Omarchy](https://omarchy.org), built on the
[cyberdream.nvim](https://github.com/scottmckendry/cyberdream.nvim) palette.

![Cyberdream on Omarchy](screenshots/desktop.webp)

## Install

From the Omarchy menu (`Super + Space`): **Install → Style → Theme**, then paste
this repo's URL. Or from a terminal:

```bash
omarchy theme install https://github.com/prdlk/omarchy-cyberdream
```

Remove it again with **Remove → Theme**, or `omarchy theme remove cyberdream`.

Requires Omarchy 4.x (the `colors.toml` theme format).

## Screenshots

| Omarchy menu | Terminal palette |
| --- | --- |
| ![Omarchy menu](screenshots/menu.webp) | ![Terminal palette](screenshots/terminal.webp) |

### Wallpapers

Six wallpapers in `backgrounds/`, in switcher order (`Super + Ctrl + Space`) —
fire lookout over a magenta pine forest, a neon great wave, a loaded van on a
foggy roadside, a crimson moon over a misty lake, a blossom tree shedding petals
into a sunset, and a rain-slick neon street:

![Cyberdream wallpapers](screenshots/wallpapers.webp)

## Palette

Every colour is taken verbatim from
[`lua/cyberdream/colors.lua`](https://github.com/scottmckendry/cyberdream.nvim/blob/main/lua/cyberdream/colors.lua)
(the `default` palette).

| Cyberdream | Hex | Omarchy key | Used for |
| --- | --- | --- | --- |
| `bg` | `#16181a` | `background` | terminal/bar/menu/lock background, ANSI 0 |
| `bg_alt` | `#1e2124` | `lighter_background` | cursor line, second surface |
| `bg_highlight` | `#3c4048` | `selection` | selections, meters, inactive borders |
| `grey` | `#7b8496` | `muted` | comments, inactive text, ANSI 8 |
| `fg` | `#ffffff` | `foreground` | text, cursor, ANSI 7/15 |
| `red` | `#ff6e5e` | `red` | errors, ANSI 1/9 |
| `green` | `#5eff6c` | `green` | strings, additions, ANSI 2/10 |
| `yellow` | `#f1ff5e` | `yellow` | warnings, ANSI 3/11 |
| `blue` | `#5ea1ff` | `accent`, `blue` | accent, borders, keyboard LEDs, ANSI 4/12 |
| `purple` | `#bd5eff` | `magenta` | keywords, ANSI 5/13 |
| `cyan` | `#5ef1ff` | `cyan` | border gradient end, ANSI 6/14 |
| `orange` | `#ffbd5e` | `orange` | numbers, modified state |
| `pink` | `#ff5ea0` | `pink` | extra key, templates only |
| `magenta` | `#ff5ef1` | `fuchsia` | extra key, templates only |

Omarchy has no palette slot for cyberdream's `pink` and `magenta`, so they are
exposed under the extra keys `pink` and `fuchsia` — unused by the built-in
templates, available to any `~/.config/omarchy/themed/*.tpl` you write.

Two deliberate deviations from the upstream terminal extras:

- ANSI 8 (bright black) is `grey` `#7b8496`, not `bg_highlight` `#3c4048`.
  Omarchy feeds one `muted` value to bright black *and* to comments, inactive
  text, and TUI dim text; `#3c4048` on `#16181a` is unreadable. This matches the
  upstream base16 build, where `base03` is `#7b8496`.
- Window, notification, and menu borders use a `blue → cyan` 45° gradient
  (`hyprland_active_border`), with `bg_highlight` for inactive borders.

## Liquid glass

Omarchy ships `blur.enabled = false`, `shadow.enabled = false` and
`rounding = 0`; `hyprland.lua` is what turns the glass on.

| Knob | Value | Why |
| --- | --- | --- |
| `decoration.rounding` | `8` | Slightly rounded — reads as glass, not as a pill. |
| `decoration.blur` | `size 6`, `passes 3`, `brightness 0.75`, `contrast 1.15`, `vibrancy 0.25`, `noise 0.015` | Near-black neon palette: the backdrop is dimmed and lifted so a 4K wallpaper never competes with the text on top of it. |
| `decoration.blur.ignore_opacity` | `true` | Apps that cannot render a transparent background themselves (Chromium-family, Electron) show blurred glass instead of raw wallpaper when Hyprland fades them. |
| `decoration.shadow` | `range 16`, active `rgba(5ea1ff27)`, inactive `rgba(0b0c0d99)` | The focused window sits in a faint accent bloom; everything else gets plain depth. |
| window opacity | `0.98 0.92` for Omarchy's `default-opacity` tag, `1.0 1.0` for terminals and video | Terminals carry their own alpha (`background_opacity`), so the compositor must not multiply it. |
| borders | `#5ea1ff → #5ef1ff` at 45°, alpha `ee`/`bb`; inactive `#3c4048aa` | The palette's blue → cyan sweep, carried at glass alpha as a lit edge. |
| layer blur | `omarchy-bar`, `-menu`, `-notifications`, `-osd`, `-clipboard`, `-emojis`, `-polkit`, `-reminders`, panels | Omarchy 4's Quickshell surfaces. The wallpaper layer and bar drag ghosts stay out. |

The shell surfaces themselves are translucent through the `shell.*.toml` files —
bar `0.62`, launcher/notifications/popups `0.78`, menu `0.80`, tooltip `0.82`.
Each file replaces one section of the `shell.toml` Omarchy generates, so their
colours are literal rather than templated.

### On a repo install, the Lua is dropped

`omarchy theme install` refuses code from a cloned theme, so Omarchy ignores
`hyprland.lua` (it names the file on stderr) and generates a borders-only one
from `colors.toml`. The `shell.*.toml` translucency survives; blur, rounding and
shadows do not. Two ways to get them back:

```bash
# 1. Load the theme's file as your own look'n'feel. It then applies to every
#    theme you switch to, so merge rather than clobber if that file is not empty.
cp ~/.config/omarchy/themes/cyberdream/hyprland.lua ~/.config/hypr/looknfeel.lua

# 2. Or install the theme as your own working copy, which Omarchy trusts:
git clone https://github.com/prdlk/omarchy-cyberdream
ln -sfn "$PWD/omarchy-cyberdream" ~/.config/omarchy/themes/cyberdream
omarchy theme set cyberdream
```

## What this theme ships

| File | Purpose |
| --- | --- |
| `colors.toml` | The palette. Omarchy generates everything else from it. |
| `hyprland.lua` | The glass: blur, rounded corners, shadows, borders, per-window opacity, layer blur. |
| `shell.bar.toml`, `shell.menu.toml`, `shell.launcher.toml`, `shell.popups.toml`, `shell.notifications.toml`, `shell.tooltip.toml` | Translucency for the Omarchy shell surfaces; each overrides one section of the generated `shell.toml`. |
| `btop.theme` | Upstream cyberdream btop theme (cyan → purple graphs). |
| `helix.toml` | Upstream cyberdream Helix theme. |
| `icons.theme` | `Yaru-blue`, matching the blue accent. |
| `gtk.css` | GTK 3 / GTK 4 / libadwaita colours for Nautilus, file choosers and GNOME dialogs. Omarchy generates none, so without it GTK apps stay Adwaita grey. Link it once: `ln -sfn ~/.local/state/omarchy/current/theme/gtk.css ~/.config/gtk-3.0/gtk.css` (and `gtk-4.0`). |
| `backgrounds/` | Six neon wallpapers, 4K or larger except the 2560×1700 street shot (`Super + Ctrl + Space` opens the switcher). |
| `preview.png` | 1800×1012 preview for the theme switcher. |

From `colors.toml` alone, Omarchy regenerates and retints: Alacritty, Foot,
Ghostty and Kitty; Hyprland borders; the Omarchy shell (bar, menu, launcher,
notifications, OSD, polkit and lock screen); Neovim (`aether.nvim`); Chromium;
VS Code / VSCodium / Cursor; Obsidian; Claude Code; Pi; tmux; GNOME; keyboard
RGB. Nothing in this repo needs to duplicate those.

A theme installed from a git repo may not ship code, so Omarchy drops any
`*.lua`, terminal config, or `vscode.json` it finds and regenerates them from
`colors.toml`. Of those, this repo ships only `hyprland.lua` — see
[On a repo install, the Lua is dropped](#on-a-repo-install-the-lua-is-dropped).
Neovim users who want the real thing can install
[cyberdream.nvim](https://github.com/scottmckendry/cyberdream.nvim) directly.

## Extras

Cyberdream configs for apps Omarchy does not theme. Copy the ones you want;
none of them are applied by installing the theme.

| App | File | Destination |
| --- | --- | --- |
| bat / delta syntax | `extras/cyberdream.tmTheme` | `~/.config/bat/themes/cyberdream.tmTheme`, then `bat cache --build` |
| delta | `extras/delta.gitconfig` | append to `~/.config/git/config`, then set `[delta] features = cyberdream` |
| fish | `extras/fish.theme` | `~/.config/fish/themes/cyberdream.theme`, then `fish_config theme choose cyberdream` |
| gitui | `extras/gitui.ron` | `~/.config/gitui/theme.ron` |
| herdr | `extras/herdr.toml` | merge into `~/.config/herdr/config.toml`, then `herdr server reload-config`. Base theme `terminal` inherits Omarchy's ANSI palette; this pins the chrome herdr paints itself — the spaces rail, the kitty-style tab plate, agent-state marks — and turns pane borders off. |
| k9s | `extras/k9s.yaml` | `~/.config/k9s/skins/cyberdream.yaml`, then `skin: cyberdream` in `config.yaml` |
| kitty tab bar | `extras/kitty.conf.tpl` | `~/.config/omarchy/themed/kitty.conf.tpl`, then `omarchy theme refresh`. Omarchy's own kitty template sets only `active_tab_background`, leaving kitty's `#999999` grey strip and black active-tab title; this replaces the template for every theme and derives the whole tab bar from the palette. |
| lazygit | `extras/lazygit.yml` | merge into `~/.config/lazygit/config.yml` |
| lsd | `extras/lsd-colors.yaml` | `~/.config/lsd/colors.yaml` |
| opencode | `extras/opencode.json` | `~/.config/opencode/themes/cyberdream.json`, then `"theme": "cyberdream"` |
| vivid (`LS_COLORS`) | `extras/vivid-cyberdream.yml` | `~/.config/vivid/themes/cyberdream.yml`, then `export LS_COLORS="$(vivid generate cyberdream)"` |
| waybar | `extras/waybar.css.tpl` | `~/.config/omarchy/themed/waybar.css.tpl`, then `omarchy theme refresh`. Omarchy 4 generates no `waybar.css` (the bar is Quickshell), so a waybar config that imports one gets GTK grey; this renders the palette for every theme. Import it from `style.css` with an absolute path to `~/.local/state/omarchy/current/theme/waybar.css`. |
| yazi | `extras/yazi-theme.toml` | `~/.config/yazi/theme.toml` |
| zed | `extras/zed-cyberdream.json` | `~/.config/zed/themes/cyberdream.json` |

## Hacking on it

```bash
git clone https://github.com/prdlk/omarchy-cyberdream
ln -sfn "$PWD/omarchy-cyberdream" ~/.config/omarchy/themes/cyberdream
omarchy theme set cyberdream          # re-run after every edit
omarchy theme refresh                 # regenerate templates without switching
```

The generated configs land in `~/.local/state/omarchy/current/theme/` — read
them to see what a `colors.toml` change actually produced.

To refresh `preview.png` after a layout change:

```bash
grim -o <output> /tmp/shot.png
magick /tmp/shot.png -resize '1800x1012!' -strip preview.png
```

To rebuild `screenshots/wallpapers.webp` after changing `backgrounds/`:

```bash
rm -rf /tmp/wpthumbs && mkdir -p /tmp/wpthumbs
for f in backgrounds/*.jpg; do
  magick "$f" -resize '464x261^' -gravity center -extent 464x261 \
    -strip /tmp/wpthumbs/"$(basename "$f" .jpg)".png
done
magick montage /tmp/wpthumbs/*.png -tile 3x2 -geometry +4+4 \
  -background '#16181a' -strip -quality 80 -define webp:method=6 \
  screenshots/wallpapers.webp
```

The wallpapers are not all 16:9, so each one is cropped to fill its cell first —
`montage -geometry 464x261` alone would letterbox the odd sizes and leave the
grid ragged.

## Listing on omarchy.org

The screenshot for [the extra themes page](https://omarchy.org/themes/) is
`screenshots/omarchy-site-cyberdream.webp` (1200px wide, as their contributing
note requires). The figure block for a PR to
[omacom-io/omarchy-site](https://github.com/omacom-io/omarchy-site), in
alphabetical order between *Crimson Gold* and *Darcula*:

```html
<figure class="themes__theme">
  <a href="https://github.com/prdlk/omarchy-cyberdream"><img src="/assets/themes/cyberdream.webp" alt="Cyberdream theme" loading="lazy" decoding="async"></a>
  <figcaption><a href="https://github.com/prdlk/omarchy-cyberdream">Cyberdream</a></figcaption>
</figure>
```

## Credits

- Palette: [cyberdream.nvim](https://github.com/scottmckendry/cyberdream.nvim) by Scott McKendry (MIT).
- Zed theme in `extras/`: Byt3m4st3r, from the upstream cyberdream extras.
- [Omarchy](https://omarchy.org) by Basecamp / DHH.
