#!/bin/bash

# Size threshold in bytes (99MB)
SIZE_THRESHOLD=$((99 * 1024 * 1024))

# Create or update .gitignore
touch .gitignore


# Find all files larger than 99MB
large_files=$(find . -type f -size +99M ! -path "*/.git/*")

# Calculate total size of large files in bytes
total_size=0
while IFS= read -r file; do
    filesize=$(stat -c%s "$file")
    total_size=$((total_size + filesize))
done <<< "$large_files"

# Log total size in human-readable format
echo "Total size of large files: $(numfmt --to=iec --suffix=B $total_size)"



# Find all files larger than 99MB
find . -type f -size +99M ! -path "*/.git/*"  | while read -r file; do
    # Get file size in bytes
    filesize=$(stat -c%s "$file")
    
    # Calculate total parts needed
    parts=$(( (filesize + SIZE_THRESHOLD - 1) / SIZE_THRESHOLD ))

    echo "$file" 

    # Determine padding width (e.g., 3 if 100+ parts)
    pad_width=${#parts}

    # Extract filename and directory
    dir=$(dirname "$file")
    base=$(basename "$file")

    # Output prefix
    output_prefix="${dir}/${base}_part"

    # Split file into 99MB chunks
    split --bytes=99M --numeric-suffixes=0 --suffix-length=$pad_width "$file" "${output_prefix}"

    # Rename output files to use _part(n)
    for part_file in "${output_prefix}"*; do
        suffix=$(echo "$part_file" | grep -oE "[0-9]{$pad_width}$")
        mv "$part_file" "${output_prefix}(${suffix})"
    done

    # Add original file path to .gitignore if not already there
    grep -qxF "$file" .gitignore || echo "${file#./}" >> .gitignore

done