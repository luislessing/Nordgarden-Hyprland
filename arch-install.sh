#!/usr/bin/env bash
# arch-install.sh — Nordgarden Hyprland Setup auf clean Arch Linux
#
# Voraussetzung: Arch Linux installiert, iwd aktiv, User eingeloggt
# Ausführen als normaler User mit sudo-Rechten: bash arch-install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'

info()  { echo -e "${GREEN}[install]${NC} $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC}   $*"; }
error() { echo -e "${RED}[error]${NC}  $*" >&2; }
step()  { echo -e "\n${GREEN}══════════════════════════════════════${NC}"; info "$*"; }

ask() {
    # ask <label> — gibt 0 zurück wenn Ja, 1 wenn Nein
    local label="$1"
    local answer
    read -rp "$(echo -e "  ${CYAN}?${NC} ${label} [Y/n] ")" answer
    [[ "${answer:-y}" =~ ^[Yy] ]]
}

# ─────────────────────────────────────────────────────────────────────────────
# 0. Sanity checks
# ─────────────────────────────────────────────────────────────────────────────

if [[ $EUID -eq 0 ]]; then
    error "Nicht als root ausführen. Als normaler User mit sudo-Rechten starten."
    exit 1
fi

if ! command -v sudo &>/dev/null; then
    error "'sudo' nicht gefunden. Bitte installieren: pacman -S sudo"
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# 1. App-Auswahl (interaktiv)
# ─────────────────────────────────────────────────────────────────────────────

step "App-Auswahl — welche optionalen Apps sollen installiert werden?"
echo ""

WANT_SPOTIFY=false
WANT_OBSIDIAN=false
WANT_SIGNAL=false
WANT_1PASSWORD=false
WANT_TEAMS=false
WANT_LAZYDOCKER=false
WANT_MARKTEXT_NOTE=false

echo -e "  ${YELLOW}Musik${NC}"
ask "Spotify (spotify-launcher)" && WANT_SPOTIFY=true
echo ""

echo -e "  ${YELLOW}Notizen & Schreiben${NC}"
ask "Obsidian"                   && WANT_OBSIDIAN=true
ask "Marktext (AppImage, muss manuell geladen werden — nur Binding)" && WANT_MARKTEXT_NOTE=true
echo ""

echo -e "  ${YELLOW}Kommunikation${NC}"
ask "Signal"                     && WANT_SIGNAL=true
ask "Microsoft Teams (teams-for-linux)" && WANT_TEAMS=true
echo ""

echo -e "  ${YELLOW}Produktivität${NC}"
ask "1Password"                  && WANT_1PASSWORD=true
echo ""

echo -e "  ${YELLOW}Development${NC}"
ask "Lazydocker (Docker TUI)"    && WANT_LAZYDOCKER=true
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# 2. Basis: git + base-devel
# ─────────────────────────────────────────────────────────────────────────────

step "Basis-Pakete (base-devel)"

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed base-devel

# ─────────────────────────────────────────────────────────────────────────────
# 3. AUR-Helper: yay
# ─────────────────────────────────────────────────────────────────────────────

step "AUR-Helper: yay"

if ! command -v yay &>/dev/null; then
    info "Baue yay aus AUR..."
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
else
    info "yay ist bereits installiert."
fi

# ─────────────────────────────────────────────────────────────────────────────
# 4. Core Pacman-Pakete (immer)
# ─────────────────────────────────────────────────────────────────────────────

step "Audio: pulseaudio entfernen, PipeWire installieren"

# pulseaudio raus falls vom archinstall vorhanden (-Rdd ignoriert Abhängigkeiten)
PULSE_PKGS=$(pacman -Qq 2>/dev/null | grep pulseaudio || true)
if [[ -n "$PULSE_PKGS" ]]; then
    info "Entferne pulseaudio-Pakete: $PULSE_PKGS"
    # shellcheck disable=SC2086
    sudo pacman -Rdd --noconfirm $PULSE_PKGS
fi

sudo pacman -S --noconfirm --needed pipewire pipewire-pulse pipewire-alsa wireplumber

step "Core-Pakete (pacman)"

PACMAN_PKGS=(
    # Hyprland Core
    hyprland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    uwsm

    # Bar & Notifications
    waybar
    mako
    libnotify

    # Terminal & Shell
    kitty
    fish

    # Editor + LazyVim-Abhängigkeiten
    neovim
    nodejs
    npm
    python
    ripgrep
    fd

    # Wallpaper
    swww

    # Audio
    pavucontrol
    playerctl

    # Screenshot & Clipboard
    grim
    slurp
    wl-clipboard
    cliphist

    # Idle & Lock
    hypridle
    hyprlock

    # Fonts
    ttf-jetbrains-mono-nerd
    noto-fonts
    noto-fonts-emoji

    # GTK / Icons
    nwg-look
    adwaita-icon-theme

    # System utils
    btop
    fastfetch
    fzf
    bat
    curl
    tmux
    jq
    brightnessctl
    pacman-contrib

    # File manager
    nautilus
    gvfs

    # Bluetooth
    bluez
    bluez-utils
    blueman

    # Polkit agent
    polkit-gnome

    # Browser
    firefox

    # XDG
    xdg-utils
    xdg-user-dirs
)

sudo pacman -S --noconfirm --needed "${PACMAN_PKGS[@]}"

# Optionale Pacman-Pakete
OPT_PACMAN=()
$WANT_SPOTIFY  && OPT_PACMAN+=(spotify-launcher)
$WANT_OBSIDIAN && OPT_PACMAN+=(obsidian)
$WANT_SIGNAL   && OPT_PACMAN+=(signal-desktop)

if [[ ${#OPT_PACMAN[@]} -gt 0 ]]; then
    info "Optionale Pacman-Pakete: ${OPT_PACMAN[*]}"
    sudo pacman -S --noconfirm --needed "${OPT_PACMAN[@]}"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 5. AUR-Pakete
# ─────────────────────────────────────────────────────────────────────────────

step "AUR-Pakete"

AUR_PKGS=(
    walker-bin
    swayosd
    cava
)

$WANT_1PASSWORD  && AUR_PKGS+=(1password)
$WANT_TEAMS      && AUR_PKGS+=(teams-for-linux)
$WANT_LAZYDOCKER && AUR_PKGS+=(lazydocker)

info "Installiere AUR-Pakete: ${AUR_PKGS[*]}"
yay -S --noconfirm --needed "${AUR_PKGS[@]}"

# ─────────────────────────────────────────────────────────────────────────────
# 6. Systemdienste aktivieren
# ─────────────────────────────────────────────────────────────────────────────

step "Systemdienste aktivieren"

sudo systemctl enable --now bluetooth
sudo systemctl enable --now iwd

systemctl --user enable --now pipewire pipewire-pulse wireplumber

# ─────────────────────────────────────────────────────────────────────────────
# 7. Verzeichnisse anlegen
# ─────────────────────────────────────────────────────────────────────────────

step "Zielverzeichnisse anlegen"

mkdir -p \
    "$HOME/.config/hypr/bindings" \
    "$HOME/.config/hypr/scripts" \
    "$HOME/.config/hypr/theme" \
    "$HOME/.config/hypr/wallpapers" \
    "$HOME/.config/kitty" \
    "$HOME/.config/waybar" \
    "$HOME/.config/mako" \
    "$HOME/.config/fish/conf.d" \
    "$HOME/.config/fish/functions" \
    "$HOME/.config/fastfetch" \
    "$HOME/.config/cava" \
    "$HOME/.local/bin" \
    "$HOME/Pictures"

# ─────────────────────────────────────────────────────────────────────────────
# 8. Configs kopieren
# ─────────────────────────────────────────────────────────────────────────────

step "Configs installieren"

# Ownership sicherstellen (falls Dateien bei früherem Lauf als root erstellt wurden)
sudo chown -R "$USER:$USER" \
    "$HOME/.config/hypr" \
    "$HOME/.config/kitty" \
    "$HOME/.config/waybar" \
    "$HOME/.config/mako" \
    "$HOME/.config/fish" \
    "$HOME/.config/fastfetch" \
    "$HOME/.config/cava" \
    "$HOME/.config/btop" \
    "$HOME/.config/nvim" \
    "$HOME/.local/bin" \
    2>/dev/null || true

CONFIG_SRC="$REPO_DIR/config"

# Hyprland
cp "$CONFIG_SRC/hypr/hyprland.conf"          "$HOME/.config/hypr/hyprland.conf"
cp "$CONFIG_SRC/hypr/monitors.conf"          "$HOME/.config/hypr/monitors.conf"
cp "$CONFIG_SRC/hypr/autostart.conf"         "$HOME/.config/hypr/autostart.conf"
cp "$CONFIG_SRC/hypr/envs.conf"              "$HOME/.config/hypr/envs.conf"
cp "$CONFIG_SRC/hypr/looknfeel.conf"         "$HOME/.config/hypr/looknfeel.conf"
cp "$CONFIG_SRC/hypr/input.conf"             "$HOME/.config/hypr/input.conf"
cp "$CONFIG_SRC/hypr/windows.conf"           "$HOME/.config/hypr/windows.conf"
cp "$CONFIG_SRC/hypr/theme/hyprland.conf"    "$HOME/.config/hypr/theme/hyprland.conf"

cp "$CONFIG_SRC/hypr/bindings/tiling.conf"    "$HOME/.config/hypr/bindings/tiling.conf"
cp "$CONFIG_SRC/hypr/bindings/media.conf"     "$HOME/.config/hypr/bindings/media.conf"
cp "$CONFIG_SRC/hypr/bindings/clipboard.conf" "$HOME/.config/hypr/bindings/clipboard.conf"
cp "$CONFIG_SRC/hypr/bindings/utilities.conf" "$HOME/.config/hypr/bindings/utilities.conf"
cp "$CONFIG_SRC/hypr/bindings/apps.conf"      "$HOME/.config/hypr/bindings/apps.conf"

cp "$CONFIG_SRC/hypr/scripts/terminal-cwd"    "$HOME/.config/hypr/scripts/terminal-cwd"
cp "$CONFIG_SRC/hypr/scripts/launch-or-focus" "$HOME/.config/hypr/scripts/launch-or-focus"
cp "$CONFIG_SRC/hypr/scripts/rotate-display"  "$HOME/.config/hypr/scripts/rotate-display"
chmod +x "$HOME/.config/hypr/scripts/"*

# Kitty, Waybar, Mako, Fish, Fastfetch, Cava
cp "$CONFIG_SRC/kitty/kitty.conf"                    "$HOME/.config/kitty/kitty.conf"
cp "$CONFIG_SRC/waybar/config.jsonc"                 "$HOME/.config/waybar/config.jsonc"
cp "$CONFIG_SRC/waybar/style.css"                    "$HOME/.config/waybar/style.css"
cp "$CONFIG_SRC/mako/config"                         "$HOME/.config/mako/config"
cp "$CONFIG_SRC/fish/conf.d/aliases.fish"            "$HOME/.config/fish/conf.d/aliases.fish"
cp "$CONFIG_SRC/fish/functions/cd.fish"              "$HOME/.config/fish/functions/cd.fish"
cp "$CONFIG_SRC/fish/functions/qcopy.fish"           "$HOME/.config/fish/functions/qcopy.fish"
cp "$CONFIG_SRC/fish/functions/pasteimg.fish"        "$HOME/.config/fish/functions/pasteimg.fish"
cp "$CONFIG_SRC/fastfetch/config.jsonc"              "$HOME/.config/fastfetch/config.jsonc"
cp "$CONFIG_SRC/cava/config"                         "$HOME/.config/cava/config"

# btop theme
mkdir -p "$HOME/.config/btop/themes"
cp "$CONFIG_SRC/btop/themes/nordgarden.theme" "$HOME/.config/btop/themes/nordgarden.theme"

# Neovim / LazyVim (komplette Config)
cp -r "$CONFIG_SRC/nvim" "$HOME/.config/nvim"
info "Neovim-Config installiert. Plugins werden beim ersten 'nvim'-Start automatisch geladen."

# tdl
cp "$REPO_DIR/bin/tdl" "$HOME/.local/bin/tdl"
chmod +x "$HOME/.local/bin/tdl"

# Wallpapers
cp "$REPO_DIR/wallpaper/"* "$HOME/.config/hypr/wallpapers/"

# ─────────────────────────────────────────────────────────────────────────────
# 9. Nicht installierte Apps aus bindings.conf auskommentieren
# ─────────────────────────────────────────────────────────────────────────────

step "Bindings anpassen (nicht installierte Apps deaktivieren)"

APPS_CONF="$HOME/.config/hypr/bindings/apps.conf"

comment_binding() {
    local pattern="$1"
    sed -i "s|^\(bindd\?.*${pattern}.*\)|# \1|" "$APPS_CONF"
}

$WANT_SPOTIFY      || comment_binding "spotify-launcher"
$WANT_SIGNAL       || comment_binding "signal-desktop"
$WANT_OBSIDIAN     || comment_binding "obsidian"
$WANT_1PASSWORD    || comment_binding "1password"
$WANT_TEAMS        || comment_binding "teams-for-linux"
$WANT_LAZYDOCKER   || comment_binding "lazydocker"
$WANT_MARKTEXT_NOTE || comment_binding "marktext.AppImage"

# ─────────────────────────────────────────────────────────────────────────────
# 10. Fish als Standard-Shell
# ─────────────────────────────────────────────────────────────────────────────

step "Fish als Standard-Shell"

if [[ "$SHELL" != "/usr/bin/fish" ]]; then
    chsh -s /usr/bin/fish
    info "Fish ist jetzt Standard-Shell (wirkt nach neuem Login)."
else
    info "Fish ist bereits Standard-Shell."
fi

# ─────────────────────────────────────────────────────────────────────────────
# 11. Hyprland-Autostart in Fish
# ─────────────────────────────────────────────────────────────────────────────

step "Hyprland Auto-Start (TTY1)"

FISH_CONFIG="$HOME/.config/fish/config.fish"
AUTOSTART_SNIPPET='
# Hyprland automatisch auf TTY1 starten
if status --is-login && test (tty) = /dev/tty1
    exec uwsm start hyprland.desktop
end
'

if ! grep -q "uwsm start hyprland" "$FISH_CONFIG" 2>/dev/null; then
    echo "$AUTOSTART_SNIPPET" >> "$FISH_CONFIG"
    info "Hyprland-Autostart zu fish/config.fish hinzugefügt."
else
    info "Hyprland-Autostart bereits vorhanden."
fi

# ─────────────────────────────────────────────────────────────────────────────

xdg-user-dirs-update

step "Installation abgeschlossen"
echo ""
echo "  Nächste Schritte:"
echo "  1. Neu einloggen (für Fish als Shell)"
echo "  2. Auf TTY1 einloggen → Hyprland startet automatisch"
echo "  3. Oder direkt starten: uwsm start hyprland.desktop"
echo ""

if $WANT_MARKTEXT_NOTE; then
    warn "Marktext: AppImage manuell nach ~/marktext.AppImage laden."
fi
warn "LazyVim: https://www.lazyvim.org (nvim-Bootstrap, manuell)"
