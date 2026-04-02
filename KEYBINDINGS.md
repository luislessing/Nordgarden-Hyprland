# Keybindings

Alle aktiven Bindings der Nordgarden Hyprland-Config.

> **Modifier-Legende:** `S` = Super (Win-Taste) · `Sh` = Shift · `C` = Ctrl · `A` = Alt

---

## Fenster & Tiling

| Shortcut | Aktion |
|---|---|
| `S + Q` | Fenster schließen |
| `S + F` | Vollbild (echtes Fullscreen) |
| `S + Sh + F` | Pseudo-Fullscreen (behält Tiling-Slot) — **KONFLIKT** (auch Nautilus, s.u.) |
| `S + Space` | Float toggle |
| `S + H/L/K/J` | Fokus links/rechts/oben/unten |
| `S + Sh + H/L/K/J` | Fenster verschieben links/rechts/oben/unten |
| `S + C + H/L/K/J` | Fenster verkleinern/vergrößern (–40/+40 px, gehalten) |
| `S + S` | Scratchpad (special workspace) toggle |
| `Alt + Tab` | Nächstes Fenster |
| `Alt + Sh + Tab` | Vorheriges Fenster |
| `S + Sh + M` | Hyprland beenden |

---

## Workspaces

| Shortcut | Aktion |
|---|---|
| `S + 1–9, 0` | Workspace 1–10 wechseln |
| `S + Sh + 1–9, 0` | Aktives Fenster auf Workspace 1–10 schieben |
| `S + Mausrad hoch/runter` | Workspaces durchblättern |
| `S + Linksklick` (halten) | Fenster mit Maus verschieben |
| `S + Rechtsklick` (halten) | Fenster mit Maus skalieren |

---

## Apps

| Shortcut | Aktion |
|---|---|
| `S + Enter` | Terminal (Kitty, öffnet im CWD) |
| `S + A + Enter` | Terminal + Tmux (öffnet im CWD) |
| `S + Sh + F` | Nautilus (neues Fenster) — **KONFLIKT** (auch Pseudo-FS, s.o.) |
| `S + A + Sh + F` | Nautilus im CWD |
| `S + Sh + B` | Firefox |
| `S + Sh + A + B` | Firefox Privatfenster |
| `S + Sh + M` | Spotify (launch-or-focus) |
| `S + Sh + N` | Neovim (in Kitty) |
| `S + Sh + D` | Lazydocker (in Kitty) |
| `S + Sh + G` | Signal (launch-or-focus) |
| `S + Sh + O` | Obsidian (launch-or-focus) |
| `S + Sh + W` | Marktext AppImage |
| `S + Sh + /` | 1Password |
| `S + Sh + T` | Teams for Linux |

---

## Utilities

| Shortcut | Aktion |
|---|---|
| `S + D` | App-Launcher (Walker) |
| `S + V` | Clipboard-Verlauf (cliphist → walker dmenu) |
| `S + Sh + L` | Bildschirm sperren (hyprlock) |
| `S + Sh + R` | Display-Rotation (normal → 90° CW → 180° → 90° CCW) |
| `Print` | Screenshot (Auswahl → Clipboard) |
| `S + Print` | Screenshot (ganzer Screen → Datei) |
| `S + Sh + Print` | Screenshot (Auswahl → Datei) |

---

## Media & Helligkeit

| Shortcut | Aktion |
|---|---|
| `XF86AudioRaiseVolume` | Lautstärke +5 % |
| `XF86AudioLowerVolume` | Lautstärke −5 % |
| `XF86AudioMute` | Lautstärke stumm/an |
| `XF86AudioMicMute` | Mikrofon stumm/an |
| `XF86AudioPlay` | Play/Pause |
| `XF86AudioNext` | Nächster Titel |
| `XF86AudioPrev` | Vorheriger Titel |
| `XF86AudioStop` | Stop |
| `XF86MonBrightnessUp` | Helligkeit +5 % |
| `XF86MonBrightnessDown` | Helligkeit −5 % |

---

## System-Events

| Shortcut | Aktion |
|---|---|
| `Caps_Lock` | Caps-Lock-OSD (swayosd) |

---

## Bekannte Konflikte

| Shortcut | Konflikt |
|---|---|
| `S + Sh + F` | `tiling.conf`: Pseudo-Fullscreen — `apps.conf`: Nautilus öffnen |
| `S + Sh + M` | `tiling.conf`: Hyprland beenden — `apps.conf`: Spotify |
| `Caps_Lock` | Doppelt in `utilities.conf` und `apps.conf` definiert (identische Aktion, harmlos) |
