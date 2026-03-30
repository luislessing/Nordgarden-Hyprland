#!/usr/bin/env bash
# test-nested.sh — Startet eine nested Hyprland-Session mit der Nordgarden-Config
#
# Keine Installation nötig. Räumt nach dem Beenden automatisch auf.
# Voraussetzung: läuft in einer bestehenden Wayland/Hyprland-Session.
#
# Beenden: SUPER+SHIFT+M im nested Fenster

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$HOME/.cache/hypr-nordgarden-test"

# ─── Cleanup on exit ─────────────────────────────────────────────────────────

cleanup() {
    echo ""
    echo "Cleanup: $TEST_DIR"
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

# ─── Test-Verzeichnis befüllen ────────────────────────────────────────────────

rm -rf "$TEST_DIR"
mkdir -p \
    "$TEST_DIR/hypr/bindings" \
    "$TEST_DIR/hypr/scripts" \
    "$TEST_DIR/hypr/theme" \
    "$TEST_DIR/waybar" \
    "$TEST_DIR/mako"

cp -r "$REPO_DIR/config/hypr/"*  "$TEST_DIR/hypr/"
cp    "$REPO_DIR/config/waybar/config.jsonc" "$TEST_DIR/waybar/config.jsonc"
cp    "$REPO_DIR/config/waybar/style.css"    "$TEST_DIR/waybar/style.css"
cp    "$REPO_DIR/config/mako/config"         "$TEST_DIR/mako/config"

# ─── Pfade anpassen ──────────────────────────────────────────────────────────

# source = ~/.config/hypr/ → TEST_DIR/hypr/
find "$TEST_DIR/hypr" -type f \
    -exec sed -i "s|~/.config/hypr/|$TEST_DIR/hypr/|g" {} \;

# $HOME/.config/hypr/ → TEST_DIR/hypr/ (literal $HOME in exec-Zeilen)
find "$TEST_DIR/hypr" -type f \
    -exec sed -i "s|\$HOME/.config/hypr/|$TEST_DIR/hypr/|g" {} \;

# ─── monitors.conf: keine Rotation, nur auto ─────────────────────────────────

cat > "$TEST_DIR/hypr/monitors.conf" << 'EOF'
# Nested: keine Rotation, automatische Größe
monitor = ,preferred,auto,1
EOF

# ─── autostart: für nested vereinfachen ──────────────────────────────────────

cat > "$TEST_DIR/hypr/autostart.conf" << EOF
# Autostart (nested Test — reduziert)

# Waybar mit Test-Config
exec-once = waybar --config $TEST_DIR/waybar/config.jsonc --style $TEST_DIR/waybar/style.css

# Notifications
exec-once = mako --config $TEST_DIR/mako/config

# Wallpaper
exec-once = swww-daemon
exec-once = sleep 0.5 && swww img "$REPO_DIR/wallpaper/wallhaven-nzmmjg.jpg" --transition-type fade --transition-duration 1
EOF

# ─── Starten ─────────────────────────────────────────────────────────────────

echo ""
echo "Starte nested Hyprland-Session..."
echo "  Config:   $TEST_DIR/hypr/hyprland.conf"
echo "  Wallpaper: $REPO_DIR/wallpaper/wallhaven-nzmmjg.jpg"
echo ""
echo "  Einmal ins Fenster klicken um Fokus zu übernehmen."
echo "  Beenden: SUPER+SHIFT+M"
echo ""

Hyprland -c "$TEST_DIR/hypr/hyprland.conf"
