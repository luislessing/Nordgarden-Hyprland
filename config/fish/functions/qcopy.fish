# Fuzzy-select files and copy their contents to the Wayland clipboard for pasting into LLMs
function qcopy
    if not command -q wl-copy
        echo "Error: 'wl-copy' is not installed. Please install wl-clipboard."
        return 1
    end

    if not command -q fzf
        echo "Error: 'fzf' is not installed. Please install fzf."
        return 1
    end

    set preview_cmd "cat {}"
    if command -q bat
        set preview_cmd "bat --style=numbers --color=always {}"
    end

    set selected_files (find . -type f -not -path "*/.git/*" 2>/dev/null | fzf --multi \
        --layout=reverse \
        --preview=$preview_cmd \
        --preview-window=right:60%:wrap \
        --prompt="Select files > " \
        --header="TAB to select, ENTER to copy, ESC to cancel")

    if test -z "$selected_files"
        echo "No files selected. Exited qcopy."
        return 0
    end

    set temp_file (mktemp)

    for file in $selected_files
        set clean_file (string replace -r '^\./' '' $file)
        echo "file name: $clean_file" >> $temp_file
        echo "file contents:" >> $temp_file
        cat $file >> $temp_file
        printf "\n----------------------------------------\n\n" >> $temp_file
    end

    cat $temp_file | wl-copy

    set file_count (count $selected_files)
    echo "Success! Copied $file_count file(s) to your Wayland clipboard."

    rm -f $temp_file
end
