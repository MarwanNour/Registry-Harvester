# echo "# this file is located in 'src/root_command.sh'"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"


# Banner
echo "    ____             _      __                    "
echo "   / __ \___  ____ _(_)____/ /________  __        "
echo "  / /_/ / _ \/ __  / / ___/ __/ ___/ / / /        "
echo " / _, _/  __/ /_/ / (__  ) /_/ /  / /_/ /         "
echo "/_/ |_|\___/\__, /_/____/\__/_/   \__, /          "
echo "    __  __ /____/                /_____           "
echo "   / / / /___ _______   _____  _____/ /____  _____"
echo "  / /_/ / __  / ___/ | / / _ \/ ___/ __/ _ \/ ___/"
echo " / __  / /_/ / /   | |/ /  __(__  ) /_/  __/ /    "
echo "/_/ /_/\__,_/_/    |___/\___/____/\__/\___/_/     "
echo ""

# Debug mode
if [[ ${args[--debug]} -eq 1 ]]; then
  inspect_args
  set -x
fi

# Check jq requirement
req_test=$(jq --version)

if [[ $? -eq 127 ]]; then
  echo "Please install jq to use this tool"
  exit 1
fi

echo ""

# Insecure
insecure=""
if [[ ${args[--insecure]} -eq 1 ]]; then
  insecure="-k"
fi

# Auth (user, pass)
auth_str=""
if [[ ! -z ${args[--user]} ]] && [[ ! -z ${args[--pass]} ]]; then
  auth_str="--user ${args[--user]}:${args[--pass]}"
fi

# Curl catalog
response=$(curl --silent $insecure $auth_str ${args[source]}/v2/_catalog)

if [[ $? -ne 0 ]]; then
  echo "Error sending request to registry"
  printf "\n$response\n"
  exit 1
fi

# Parse catalog
repositories=$(echo $response | jq -r .repositories[])
printf "\n\nAvailable Repositories:\n\n$repositories\n\n"

read -p "Choose a repository from the items above: " repository 

# Loop over repositories
for repo in $repositories; do
  # Check if input is correct
  if [[ $repository == $repo ]]; then
    # Get tags
    response=$(curl --silent $insecure $auth_str ${args[source]}/v2/$repo/tags/list)
    
    # Parse tags
    tags=$(echo $response | jq -r .tags[])
    printf "\n\nAvailable Tags:\n\n$tags\n\n"

    read -p "Choose a tag from the items above: " tag 

    # Loop over tags
    for t in $tags; do
      # Check if input is correct
      if [[ $tag == $t ]]; then
        # Get manifest
        response=$(curl --silent $insecure $auth_str ${args[source]}/v2/$repo/manifests/$tag)
        blobs=$(echo $response | jq -r .fsLayers[].blobSum)
        echo $blobs

        # TODO: Save blobs in a set (no duplicates)
        # TODO: Download blobs as .tar.gz in output folder 

        # Return/Exit 0
        exit 0
      fi
    done

    # Exit with error if tag is incorrect after loop
    echo "Error: Incorrect Tag"
    exit 1
  fi
done

# Exit with error if repo is incorrect after loop
echo "Error: Incorrect repository"
exit 1
