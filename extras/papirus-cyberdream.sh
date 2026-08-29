#!/usr/bin/env bash
# Recolour Papirus folders to the Cyberdream palette.
#
# Papirus ships ~25 folder colours; none of them is the theme's neon. This
# derives a new colour set from the violet one — same artwork, three hex
# substitutions — and switches Papirus to it.
#
#   pacman -S papirus-icon-theme papirus-folders   # papirus-folders is in the AUR
#   extras/papirus-cyberdream.sh                   # purple (default)
#   extras/papirus-cyberdream.sh --color blue      # or the accent blue
#   extras/papirus-cyberdream.sh --color cyan
#
# Without papirus-folders installed the colour set is still generated; select it
# yourself by copying folder-cyberdream*.svg over folder*.svg, or install the
# script from https://github.com/PapirusDevelopmentTeam/papirus-folders.

set -euo pipefail

COLOR=purple
NAME=cyberdream

while (($#)); do
  case "$1" in
    --color) COLOR="${2:?--color needs a value}"; shift 2 ;;
    --name) NAME="${2:?--name needs a value}"; shift 2 ;;
    -h | --help) sed -n '2,16p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 1 ;;
  esac
done

# Cyberdream, and the two shades Papirus draws under the front face. The ratios
# are the ones the stock violet folder uses (0.74 / 0.65 / 0.80 for the back,
# 0.35 for the deep shade), so the artwork keeps its depth.
case "$COLOR" in
  purple) MAIN=bd5eff BACK=8b3dcb DEEP=422059 ;;
  blue)   MAIN=5ea1ff BACK=4477cb DEEP=1f3559 ;;
  cyan)   MAIN=5ef1ff BACK=44b3cb DEEP=1f4b59 ;;
  *) echo "unknown colour: $COLOR (purple, blue, cyan)" >&2; exit 1 ;;
esac

# Stock violet hexes, in the same order.
FROM=(7e57c2 5d399b 2c1e44)
TO=("$MAIN" "$BACK" "$DEEP")

themes=()
for dir in "$HOME/.local/share/icons" "$HOME/.icons" /usr/share/icons; do
  for theme in Papirus Papirus-Dark Papirus-Light; do
    [[ -d "$dir/$theme" && -w "$dir/$theme" ]] && themes+=("$dir/$theme")
  done
done

if ((${#themes[@]} == 0)); then
  echo "No writable Papirus install found. Install papirus-icon-theme, or copy" >&2
  echo "/usr/share/icons/Papirus-Dark to ~/.local/share/icons first." >&2
  exit 1
fi

generated=0
for theme in "${themes[@]}"; do
  while IFS= read -r -d '' src; do
    dst="${src//folder-violet/folder-$NAME}"

    if [[ -L $src ]]; then
      target=$(readlink "$src")
      ln -sfn "${target//folder-violet/folder-$NAME}" "$dst"
    else
      sed -e "s/#${FROM[0]}/#${TO[0]}/g" \
          -e "s/#${FROM[1]}/#${TO[1]}/g" \
          -e "s/#${FROM[2]}/#${TO[2]}/g" \
          "$src" >"$dst"
    fi
    generated=$((generated + 1))
  done < <(find "$theme" -name 'folder-violet*.svg' -print0)
done

echo "Generated $generated folder-$NAME icons in ${#themes[@]} Papirus install(s)."

if command -v papirus-folders >/dev/null; then
  for theme in "${themes[@]}"; do
    PAPIRUS_DIR=$(dirname "$theme") papirus-folders -C "$NAME" -t "$(basename "$theme")"
  done
else
  echo "papirus-folders not installed — colour set generated but not selected." >&2
fi

if command -v gtk-update-icon-cache >/dev/null; then
  for theme in "${themes[@]}"; do
    gtk-update-icon-cache -qf "$theme" 2>/dev/null || true
  done
fi
