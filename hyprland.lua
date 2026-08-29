-- Cyberdream for Omarchy 4 -- the glass looknfeel.
--
-- Loaded by default/hypr/omarchy.lua as `omarchy.current.theme.hyprland`, i.e.
-- after Omarchy's default looknfeel/windows/apps and before ~/.config/hypr/*.lua.
-- Omarchy's defaults ship `blur.enabled = false` and `shadow.enabled = false`,
-- so this file is what turns the glass on. Later rules win, so the window rules
-- at the bottom override the default `0.985 0.96` opacity Omarchy tags onto
-- every window.
--
-- `omarchy theme install` refuses Lua from a cloned theme, so on a repo install
-- Omarchy drops this file and prints it on stderr. See "Liquid glass" in
-- README.md for the two ways to get it back.

-- blue -> cyan, the same sweep colors.toml hands the shell for its borders,
-- carried at glass alpha so the border reads as a lit edge, not a frame.
local active_border = { colors = { "rgba(5ea1ffee)", "rgba(5ef1ffbb)" }, angle = 45 }
local inactive_border = "rgba(3c4048aa)"
local locked_border = { colors = { "rgba(bd5effee)", "rgba(ff5ea0bb)" }, angle = 45 }

hl.config({
  decoration = {
    -- Slightly rounded: enough to read as glass, not a pill.
    rounding = 8,

    -- Global fallback. Omarchy tags every mapped window `default-opacity` and
    -- fades it, so the per-window rules at the bottom are what actually apply.
    active_opacity = 1.0,
    inactive_opacity = 0.94,
    fullscreen_opacity = 1.0,

    shadow = {
      enabled = true,
      range = 10,
      render_power = 3,
      offset = { 0, 2 },
      scale = 1.0,
      -- Depth, not a halo: a tight accent tint on the focused window (alpha
      -- 0x1a) and plain darker_background behind everything else. The bloom
      -- started at range 16 / 0x2e and reads as border glow well before that.
      color = "rgba(5ea1ff1a)",
      color_inactive = "rgba(0b0c0d88)",
    },

    blur = {
      enabled = true,
      size = 6,
      passes = 3,
      -- Cyberdream is near-black neon: dim and lift the backdrop so the
      -- wallpaper behind a window never competes with the text on top of it.
      brightness = 0.75,
      contrast = 1.15,
      vibrancy = 0.25,
      vibrancy_darkness = 0.4,
      noise = 0.015,
      new_optimizations = true,
      popups = true,
      popups_ignorealpha = 0.2,

      -- Keeps the blurred backdrop under a window the compositor merely fades.
      -- Without it, an app that cannot render a transparent background itself
      -- (Chromium-family, Electron) shows raw wallpaper instead of glass.
      ignore_opacity = true,
    },
  },

  general = {
    col = {
      active_border = active_border,
      inactive_border = inactive_border,
    },
  },

  group = {
    col = {
      border_active = active_border,
      border_inactive = inactive_border,
      border_locked_active = locked_border,
      border_locked_inactive = "rgba(3c404899)",
    },

    groupbar = {
      -- Dark plates on top of a blurred window, and rounded to match the
      -- windows they tab.
      col = {
        active = "rgba(1e2124cc)",
        inactive = "rgba(16181a99)",
      },
      text_color = "rgb(ffffff)",
      text_color_inactive = "rgb(7b8496)",
      gradient_rounding = 8,
    },
  },
})

-- Blur the shell's layer surfaces: bar, menu, notifications, OSD, and every
-- panel that opens off them. `omarchy-background` is the wallpaper itself and
-- the `*-ghost` namespaces are bar drag previews, so both stay out.
hl.layer_rule({
  match = {
    namespace = "^(omarchy-bar|omarchy-menu|omarchy-notifications|omarchy-osd|omarchy-clipboard|omarchy-emojis|omarchy-image-selector|omarchy-keyboard-panel|omarchy-polkit|omarchy-reminders|omarchy-network-qr|omarchy-speed-test|omarchy-disk-speedtest|omarchy-network-speedtest)$",
  },
  blur = true,
  blur_popups = true,
  ignore_alpha = 0.1,
})

-- Windows Omarchy fades by default: deepen it a little, because `ignore_opacity`
-- above means the fade now reveals blurred glass rather than wallpaper.
o.window({ tag = "default-opacity" }, { opacity = "0.98 0.92" })

-- Terminals carry their own alpha (kitty's `background_opacity`, Alacritty's
-- `window.opacity`, ...), so the compositor must leave them at 1.0 or the two
-- multiply and the text goes grey. Omarchy's `terminal` tag misses the extra
-- app-ids a user launches kitty under (kitty-tmux, kitty-herdr), hence the
-- second, wider class match.
o.window({ tag = "terminal" }, { opacity = "1.0 1.0" })
o.window("(kitty|Alacritty|com\\.mitchellh\\.ghostty|foot|wezterm)(-.*)?", { opacity = "1.0 1.0" })

-- Video and video-call surfaces stay opaque; translucent playback looks broken.
o.window("(^.+-youtube\\.com__.*$|^.+-app\\.zoom\\.us__wc_home.*$|^.+-meet\\.google\\.com__.*$)", { opacity = "1.0 1.0" })
