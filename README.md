# Nordgarden Hyprland Setup

Minimales Arch Linux + Hyprland Setup mit dem Nordgarden-Theme.
Kein Omarchy OS — läuft auf einem sauberen `archinstall`.

## Voraussetzungen

- Arch Linux (via `archinstall`) mit Netzwerkzugang
- `iwd` + `git` vorinstalliert
- Normaler User mit `sudo`-Rechten

## Installation

```bash
git clone <repo-url> nordgarden-hyprland
cd nordgarden-hyprland
bash arch-install.sh
```

Das Script fragt interaktiv, welche optionalen Apps installiert werden sollen, und kommentiert Keybinds für nicht-installierte Apps automatisch aus.

Nach der Installation:
1. Neu einloggen (Fish als Standard-Shell)
2. Auf TTY1 einloggen → Hyprland startet automatisch via `uwsm`

## Was installiert wird

### Core (immer)

| Komponente | Paket |
|------------|-------|
| Window Manager | `hyprland` |
| Status Bar | `waybar` |
| Terminal | `kitty` |
| Shell | `fish` |
| Editor | `neovim` + LazyVim (automatisch) |
| App Launcher | `walker` |
| Notifications | `mako` |
| Wallpaper | `swww` |
| Audio | `pipewire` + `wireplumber` |
| Bluetooth | `bluez` + `blueman` |
| Browser | `firefox` |
| Idle / Lock | `hypridle` + `hyprlock` |
| Audio Visualizer | `cava` |
| Clipboard | `cliphist` + `wl-clipboard` |
| Screenshots | `grim` + `slurp` |

### Optional (interaktive Auswahl)

| App | Keybind |
|-----|---------|
| Spotify | `SUPER+SHIFT+M` |
| Obsidian | `SUPER+SHIFT+O` |
| Marktext | `SUPER+SHIFT+W` (AppImage manuell) |
| Signal | `SUPER+SHIFT+G` |
| Microsoft Teams | `SUPER+SHIFT+T` |
| 1Password | `SUPER+SHIFT+/` |
| Lazydocker | `SUPER+SHIFT+D` |

## Keybindings

### Fenster

| Keybind | Aktion |
|---------|--------|
| `SUPER+Q` | Fenster schließen |
| `SUPER+F` | Fullscreen |
| `SUPER+SPACE` | Float toggle |
| `SUPER+H/J/K/L` | Fokus wechseln |
| `SUPER+SHIFT+H/J/K/L` | Fenster verschieben |
| `SUPER+CTRL+H/J/K/L` | Fenstergröße ändern |
| `SUPER+1–9` | Workspace wechseln |
| `SUPER+SHIFT+1–9` | Fenster zu Workspace |
| `SUPER+S` | Scratchpad toggle |
| `SUPER+SHIFT+M` | Hyprland beenden |

### Apps

| Keybind | App |
|---------|-----|
| `SUPER+RETURN` | Kitty (im CWD des aktiven Fensters) |
| `SUPER+ALT+RETURN` | Kitty + tmux |
| `SUPER+D` | Walker (Launcher) |
| `SUPER+V` | Clipboard-Picker |
| `SUPER+SHIFT+B` | Firefox |
| `SUPER+SHIFT+N` | Neovim |
| `SUPER+SHIFT+F` | Nautilus |

### System

| Keybind | Aktion |
|---------|--------|
| `SUPER+SHIFT+L` | Bildschirm sperren |
| `PRINT` | Screenshot → Clipboard |
| `SUPER+PRINT` | Vollbild-Screenshot |
| `SUPER+SHIFT+PRINT` | Auswahlbereich → Datei |
| `XF86Audio*` | Lautstärke / Wiedergabe |
| `XF86Brightness*` | Helligkeit |

## Struktur

```
.
├── arch-install.sh          Installations-Script
├── bin/
│   └── tdl                  Tmux-Layout: nvim + opencode + claude
├── config/                  Spiegelt ~/.config/
│   ├── hypr/
│   │   ├── hyprland.conf    Haupt-Config (keine Omarchy-Sources)
│   │   ├── monitors.conf    Monitor: preferred, auto, 1×, 90°CW
│   │   ├── autostart.conf   Waybar, swww, mako, cliphist, hypridle
│   │   ├── envs.conf        Wayland-Umgebungsvariablen
│   │   ├── looknfeel.conf   Gaps, Blur, Shadow, Animationen
│   │   ├── input.conf       Tastatur (DE), Touchpad, Gesten
│   │   ├── windows.conf     Window Rules
│   │   ├── theme/           Nordgarden Farben (Border, Shadow)
│   │   ├── bindings/        Keybindings (tiling, media, apps…)
│   │   └── scripts/
│   │       ├── terminal-cwd    Aktives-Fenster-CWD via hyprctl
│   │       └── launch-or-focus Focus-or-launch via hyprctl
│   ├── kitty/               Terminal + Nordgarden-Farben inline
│   ├── waybar/              Bar + Nordgarden-CSS
│   ├── mako/                Notifications
│   ├── fish/                Shell: aliases, cd, qcopy, pasteimg
│   ├── fastfetch/           System-Info (Arch-Logo, ohne chafa)
│   ├── cava/                Audio-Visualizer
│   ├── btop/themes/         Nordgarden btop-Theme
│   └── nvim/                LazyVim-Config (nordfox, neo-tree, transparency…)
└── wallpaper/               7× Nordgarden Wallpapers (Wallhaven)
```

## Theme

**Nordgarden** — Kombination aus Nord, Evergarden und einem Pokemon-inspirierten Waybar-Layout.

| Rolle | Farbe |
|-------|-------|
| Background | `#2e3440` — Nord Polar Night |
| Foreground | `#d8dee9` — Nord Snow Storm |
| Akzent / Cursor | `#88c0d0` — Nord Frost Cyan |
| Teal | `#8fbcbb` |
| Grün | `#cbe3b3` — Evergarden |
| Rot | `#bf616a` — Nord Aurora |

## Manuelle Schritte nach der Installation

- **LazyVim**: Config wird automatisch installiert. Beim ersten `nvim`-Start laden alle Plugins selbstständig (lazy.nvim bootstrapt sich). Colorscheme: `nordfox` (nightfox.nvim)
- **Marktext**: AppImage manuell nach `~/marktext.AppImage` laden
- **Monitor anpassen**: `~/.config/hypr/monitors.conf` — rotation (`transform`) oder scale bei Bedarf ändern
- **Tastaturlayout**: `~/.config/hypr/input.conf` — `kb_layout = de` ggf. anpassen
- **Wallpaper wechseln**: `swww img ~/.config/hypr/wallpapers/<datei>.jpg`
- **tdl**: erfordert `opencode` und `claude` CLI

## Nested Hyprland (Config testen)

Hyprland läuft nested innerhalb einer laufenden Wayland-Session — kein Risiko für das Host-System:

```bash
# Mit dieser Config testen:
Hyprland -c /pfad/zum/repo/config/hypr/hyprland.conf

# Fokus: ins Fenster klicken
# Beenden: SUPER+SHIFT+M
```
