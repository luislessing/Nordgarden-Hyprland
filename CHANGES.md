# Änderungen an den installierten Config-Files

## 1. Neues Script: Display-Rotation

Datei anlegen: `~/.config/hypr/scripts/rotate-display`

```bash
#!/bin/bash
# Cycle display rotation for the active monitor
# transform: 0=normal, 1=90°CW, 2=180°, 3=90°CCW

monitor=$(hyprctl monitors -j | jq -r '.[0].name')
current=$(hyprctl monitors -j | jq '.[0].transform')
next=$(( (current + 1) % 4 ))

hyprctl keyword monitor "$monitor,preferred,auto,1,transform,$next"
```

Danach ausführbar machen:
```
chmod +x ~/.config/hypr/scripts/rotate-display
```

---

## 2. Keybind für Rotation

Datei: `~/.config/hypr/bindings/utilities.conf`

Vor dem Caps Lock Eintrag einfügen:

```
# Display rotation (cycles: normal → 90°CW → 180° → 90°CCW)
bind = SUPER SHIFT, R, exec, ~/.config/hypr/scripts/rotate-display
```

---

## 3. fakefullscreen fixen

Datei: `~/.config/hypr/bindings/tiling.conf`

Alte Zeile:
```
bind = SUPER SHIFT, F, fakefullscreen
```

Ersetzen durch:
```
bind = SUPER SHIFT, F, fullscreen, 1
```

---

## 4. movetospecialworkspace entfernen

Datei: `~/.config/hypr/bindings/tiling.conf`

Diese Zeile löschen:
```
bind = SUPER SHIFT, S, movetospecialworkspace, scratch
```

Die andere Zeile (`togglespecialworkspace`) bleibt.
