# Paste clipboard image to a PNG file
# Usage: pasteimg [filename]   (default: clipboard.png)
function pasteimg
    set name (or $argv[1] "clipboard.png")
    if not string match -q "*.png" $name
        set name "$name.png"
    end
    wl-paste --type image/png | sudo tee $name > /dev/null
    echo "Saved to $name"
end
