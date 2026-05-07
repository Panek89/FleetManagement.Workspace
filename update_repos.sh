# Linux: Run chmod +x update_repos.sh once, then execute it with ./update_repos.sh.
#!/bin/bash

 # Get the absolute path of the directory where the script is located
 PARENT_DIR="$(cd "$(dirname "$0")" && pwd)"
 cd "$PARENT_DIR"

 echo "Checking for Git repositories in: $PARENT_DIR"

 # Ensure submodules are initialized/updated FIRST
 echo -e "\n\e[35m>>> Initializing/Updating Submodules... <<<\e[0m"
 git submodule update --init --recursive --remote

 updated_count=0

 # Loop through all items in the directory
 for d in *; do
     # Check if it's a directory and if it contains a .git folder or file (submodule)
     if [ -d "$d" ] && [ -e "$d/.git" ]; then
         echo -e "\n\e[36m>>> Updating: $d <<<\e[0m"
         # Using a subshell to perform git pull
         (cd "$d" && git pull)
         ((updated_count++))
     fi
 done

 if [ $updated_count -eq 0 ]; then
     echo -e "\n\e[31mNo Git repositories found!\e[0m"
     echo "Common reasons:"
     echo "1. The folders FleetManagement.* do not have a .git subfolder inside."
     echo "2. You are running the script from a different location."
     echo -e "\nItems found in this folder:"
     ls -F
 else
     echo -e "\n\e[32mDone! Updated $updated_count repositories.\e[0m"
 fi

 read -p "Press Enter to close..."