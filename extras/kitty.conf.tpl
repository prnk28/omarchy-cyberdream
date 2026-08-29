# Omarchy's built-in kitty template colors the terminal but sets only
# `active_tab_background`, so kitty's own defaults paint the rest of the tab bar:
# a #999999 grey strip with #444444 titles and black text on the active tab. On a
# near-black neon palette that is the ugliest thing on screen.
#
# Drop this file in ~/.config/omarchy/themed/kitty.conf.tpl to replace the
# built-in template for every theme -- the tab bar is then derived from the
# active palette: a deep accent-tinted plate for the current tab, the window
# background for the rest, muted titles, no grey.
#
#   mkdir -p ~/.config/omarchy/themed
#   cp extras/kitty.conf.tpl ~/.config/omarchy/themed/kitty.conf.tpl
#   omarchy theme refresh
#
# Everything above the tab-bar block is Omarchy's template verbatim; keep it in
# sync when Omarchy's own kitty.conf.tpl changes.

foreground {{ foreground }}
background {{ background }}
selection_foreground {{ selection_foreground }}
selection_background {{ selection_background }}

cursor {{ bright_foreground }}
cursor_text_color {{ background }}

active_border_color {{ accent }}
inactive_border_color {{ selection }}
bell_border_color {{ orange }}
url_color {{ cyan }}

# Tab bar: active tab is the accent mixed 20% into the background, so it reads as
# a lit plate rather than a solid accent block, with the accent kept for its
# title. Inactive tabs sit flush with the window background.
tab_bar_background none
tab_bar_margin_color none
active_tab_background {{ mix accent background 80% }}
active_tab_foreground {{ accent }}
active_tab_font_style bold
inactive_tab_background {{ background }}
inactive_tab_foreground {{ muted }}
inactive_tab_font_style normal

color0 {{ background }}
color1 {{ red }}
color2 {{ green }}
color3 {{ yellow }}
color4 {{ blue }}
color5 {{ magenta }}
color6 {{ cyan }}
color7 {{ foreground }}
color8 {{ muted }}
color9 {{ bright_red }}
color10 {{ bright_green }}
color11 {{ bright_yellow }}
color12 {{ bright_blue }}
color13 {{ bright_magenta }}
color14 {{ bright_cyan }}
color15 {{ bright_foreground }}
