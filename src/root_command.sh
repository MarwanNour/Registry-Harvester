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
debug=0
if [[ (! -z "${args[--debug]}") ||  (! -z "${args[-d]}") ]]; then
  set -x 
  debug=1
fi

# Check jq requirement
req_test=$(jq --version)

if [[ $? -eq 127 ]]; then
  echo "Please install jq to use this tool"
  exit 1
fi




echo ""

response=$(curl --silent  ${args[source]})

if [[ $? -ne 0 ]]; then
  echo "Error sending request to registry"
  printf "\n$response\n"
  exit 1
fi

if [[ $debug -eq 1 ]]; then
  printf "\n$response\n"
fi

