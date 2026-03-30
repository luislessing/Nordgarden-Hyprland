# Override cd to show directory contents after navigating
function cd
    builtin cd $argv
    and ls
end
