#!/bin/bash

directories=$(find ./* -type d -prune)
lambdi="{"
count=0

for dir in $directories; do
    lambdi="$lambdi\"$count\": \"$(cat $dir/lambda_def.json)\", "
    count=$((count+1))
done

lambdi="${lambdi::-2}}"
echo "$lambdi" > lambdi.json

echo "Lambda metadata created in lambdi.json"





















# #!/bin/bash

# # Step 1: List all directories in the current location
# directories=$(find ./* -type d -prune)

# # Step 2: Initialize variables for JSON objects
# dirs="["
# lambdi="{"
# count=0

# # Step 3: Iterate through directories and build JSON objects
# for dir in $directories; do
#     # Step 3a: Check if lambda_def.json exists in the directory
#     if [ -f "$dir/lambda_def.json" ]; then
#         # Step 3b: Add directory to dirs JSON array
#         dirs="$dirs\"$(echo "$dir" | sed 's/.\///')\","
#         # Step 3c: Add lambda_def.json content to lambdi JSON object
#         lambdi="$lambdi\"$count\": $(cat "$dir/lambda_def.json"), "
#         count=$((count+1))
#     else
#         # Step 3d: Print a warning if lambda_def.json is not found in the directory
#         echo "Warning: $dir does not contain lambda_def.json"
#     fi
# done

# # Step 4: Format and close JSON objects
# dirs="${dirs::-1}]"
# lambdi="${lambdi::-2}}"

# # Step 5: Output JSON objects to lambdi.json file
# echo "$lambdi" > lambdi.json
# echo "$dirs"

#!/bin/bash
# ohne Params, gibt es eine Liste von allen Verzeichnissen aus dem aktuellen Verzeichnis aus.
# Erstellt ein JSON-Objekt mit allen Lambda-Definitionen

