#!/bin/bash

git config --global status.showUntrackedFiles all

# Ensure an argument is passed to the script
if [ -z "$1" ]; then
    echo "Usage: ./G.sh <commit-message>"
    exit 1
fi

# Store the first argument as the commit message
commit_message="$1"

# Execute git commands

#!/bin/bash



# Get a list of files that are modified or newly created, excluding deletions
files_to_add=$(git status --porcelain | grep -E '^(A| M|\?\?)' | cut -c 4-)


# Calculate the total size of those files
total_size=$(printf "$files_to_add" | xargs du -ch | grep total$ | cut -f1)

echo "Total size of modified or newly created files: $total_size"
[ "$1" == "--getsize" ] && exit 0



# echo -e "$files_to_add"

# Check if there are files to add
if [ -z "$files_to_add" ]; then
    echo "No files to commit"
    exit 0
fi

string="G.sh
\"商业博弈 Search 1.json\""

total_g_size=0

max_total=$((500 * 1024 * 1024))    # 500MB
max_file=$((99 * 1024 * 1024 + 102400))      # 99MB



# Decode chinese characters, emoji back to original
files_to_add=$(printf %b "$files_to_add\n")
# Split string by newline into an array
IFS=$'\n' read -rd '' -a files <<<"$files_to_add"

# echo $files_to_add

# Print the array to verify
for file in "${files[@]}"; do
    # original_string='This is a "quoted" string.'
    # escaped_string=$(printf '%q' "$file")
    if [[ "$file" =~ ^\".*\"$ ]]; then
        # If it starts and ends with quotes, slice the first and last characters
        file="${file:1:-1}"
    else
        # Otherwise, keep the original string
        file="$file"
    fi

    
    size=$(stat -c%s "$file")
    

    # echo "File = ${file}, size = ${size}, size<max=$([ "$size" -lt "$max_file" ] && echo true || echo false), total_g_size=${total_g_size}, total<500MB=$([ "$total_g_size" -lt "$max_total" ] && echo true || echo false)"

    if [ "$size" -lt "$max_file" ] && (( total_g_size + size < max_total )); then
        # echo $file
        total_g_size=$((total_g_size + size))
        git add "${file}"
    else
        :
    fi


    
done

commit_message="$1"

# Ensure an argument is passed to the script
if [ -z "$1" ]; then
    echo "Usage: ./G.sh <commit-message>"
    exit 1
fi

# Store the first argument as the commit message
commit_message="$1"
echo "\nCommit Message: $commit_message"
git commit --quiet -m "$commit_message"
git push origin HEAD

bash "Delete Added Committed Pushed Files.sh"
# !!! Important - convert encode back (decode)
# https://stackoverflow.com/questions/73889449/convert-a-character-from-and-to-its-decimal-binary-octal-or-hexadecimal-repre
# Section: Convert a character from and to its octal representation

# code="G.sh
# README.md
# \345\225\206\344\270\232\345\215\232\345\274\210 Search 1.json"
# code=$(printf %b "$code\n")
# echo $code
 