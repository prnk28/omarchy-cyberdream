/* Omarchy 4 generates no waybar.css — the bar is Quickshell now — so a waybar
 * config that still does `@import ".../current/theme/waybar.css"` gets an empty
 * palette and falls back to GTK grey.
 *
 * Drop this file in ~/.config/omarchy/themed/waybar.css.tpl and Omarchy renders
 * it into the staged theme for *every* theme, so waybar tracks theme switches
 * the way it did under Omarchy 3:
 *
 *   mkdir -p ~/.config/omarchy/themed
 *   cp extras/waybar.css.tpl ~/.config/omarchy/themed/waybar.css.tpl
 *   omarchy theme refresh
 *
 * Then import the generated file from ~/.config/waybar/style.css (absolute
 * path — the Omarchy 3 location ~/.config/omarchy/current is gone):
 *
 *   @import "/home/<you>/.local/state/omarchy/current/theme/waybar.css";
 */

@define-color background {{ background }};
@define-color dark_background {{ dark_background }};
@define-color darker_background {{ darker_background }};
@define-color lighter_background {{ lighter_background }};
@define-color selection {{ selection }};

@define-color foreground {{ foreground }};
@define-color bright_foreground {{ bright_foreground }};
@define-color muted {{ muted }};

@define-color accent {{ accent }};
@define-color red {{ red }};
@define-color green {{ green }};
@define-color yellow {{ yellow }};
@define-color blue {{ blue }};
@define-color magenta {{ magenta }};
@define-color cyan {{ cyan }};
@define-color orange {{ orange }};
@define-color pink {{ pink }};
@define-color fuchsia {{ fuchsia }};

/* State classes waybar sets on battery, network, and custom modules. */
@define-color warning {{ yellow }};
@define-color critical {{ red }};

/* Bars that draw their own plate want the wallpaper behind the gaps. */
@define-color transparent rgba(0, 0, 0, 0);
