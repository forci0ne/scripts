#!/bin/bash
set -e  # Exit immediately if any command fails

# Display ASCII Art Header
cat << "EOF"
██╗   ██╗██╗   ██╗███████╗██████╗
██║   ██║██║   ██║██╔════╝██╔══██╗
██║   ██║██║   ██║███████╗██║  ██║
╚██╗ ██╔╝██║   ██║╚════██║██║  ██║
 ╚████╔╝ ╚██████╔╝███████║██████╔╝
  ╚═══╝   ╚═════╝ ╚══════╝╚═════╝

██████╗ ██████╗ ███████╗██████╗  █████╗ ██████╗ ███████╗
██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝
██████╔╝██████╔╝█████╗  ██████╔╝███████║██████╔╝█████╗
██╔═══╝ ██╔══██╗██╔══╝  ██╔═══╝ ██╔══██║██╔══██╗██╔══╝
██║     ██║  ██║███████╗██║     ██║  ██║██║  ██║███████╗
╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝

███████╗ ██████╗██████╗ ██╗██████╗ ████████╗
██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝
███████╗██║     ██████╔╝██║██████╔╝   ██║
╚════██║██║     ██╔══██╗██║██╔═══╝    ██║
███████║╚██████╗██║  ██║██║██║        ██║
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝


EOF

# --- Pre-check: Remove previous run artifacts if needed ---
read -p "Has this script been run before? If yes, it will remove all existing relevant info and start with a clean install. Please backup any important information before. (yes/no): " alreadyRun
if [[ "$alreadyRun" =~ ^[Yy] ]]; then
  if [ -d "valis/subseeds" ]; then
    echo "Removing existing 'valis/subseeds' directory..."
    rm -rf valis/subseeds
  fi
  if [ -f "valis/valis.conf" ]; then
    echo "Removing existing 'valis.conf' file..."
    rm -f valis/valis.conf
  fi
fi

# --- Create and enter the working directory ---
mkdir -p valis
cd valis

# --- Environment Setup ---
echo "Setting up environment..."
sudo apt update -qq && sudo apt upgrade -y -qq
sudo apt install -y -qq apache2 gcc gdb cmake nethogs libnanomsg-dev websocketd libgmp-dev uuid-dev libssl-dev curl python3

if [ ! -d "secp256k1" ]; then
  echo "Building secp256k1..."
  git clone -q https://github.com/bitcoin-core/secp256k1
  cd secp256k1
  cmake -DSECP256K1_ENABLE_MODULE_RECOVERY=ON . > /dev/null
  make > /dev/null
  sudo make install > /dev/null
  sudo ldconfig > /dev/null
  cd ..
else
  echo "secp256k1 already built. Skipping clone and build."
fi

# --- Download the CLI file ---
echo "Downloading CLI file..."
if [ -f "vcli" ]; then
  rm -f vcli
fi
wget -q https://github.com/valis-team/tockchain/raw/refs/heads/main/CoreTestnet/CLI/tockchain-vusd-core-cli-v2.1.0
mv tockchain-vusd-cli-v2.0.1 vcli
chmod +x vcli

# --- User Input (First Run) ---
echo ""
read -sp "Enter password (first run): " password
echo ""
read -p "Enter 3 capital letters for Vanity ID: " vanity
if ! [[ "$vanity" =~ ^[A-Z]{3}$ ]]; then
  echo "Error: Please enter exactly 3 capital letters."
  exit 1
fi

# --- Define termination trigger ---
TARGET_LINE="Valis CLI Wallet address."

# --- Run vcli (First Run: Vanity Generator) ---
echo "Starting first run with vanity generator..."
{
  echo "$vanity"
} | ./vcli "$password" 2>&1 | tee vcli_output.log > /dev/null &
vcli_pid=$!

# (Optional check for initial output)
sleep 1
if ! grep -q "First time use of that password that hashes" vcli_output.log; then
  echo "Warning: Expected initial line not detected."
fi

echo "Waiting for seed generation (first run)..."
while true; do
    if grep -q "$TARGET_LINE" vcli_output.log; then
        echo "Seed generation complete."
        break
    fi
    sleep 1
done

# --- Extract and display first run seed information ---
important_info=$(awk '/^took /, /Valis CLI Wallet address\./' vcli_output.log)
echo "---------------------------------------------"
echo "IMPORTANT SEED INFORMATION (First Run):"
echo "$important_info"
echo "---------------------------------------------"
echo "$important_info" > seed1.bak

kill $vcli_pid
echo "First run terminated."

# --- Extract address and seed for import ---
addr0=$(grep "generates address" seed1.bak | head -n1 | sed -E 's/.*generates address ([^ ]+).*/\1/')
extracted_seed=$(grep "seedstr.(" seed1.bak | sed -E 's/.*seedstr.\(([^)]*)\).*/\1/')
echo "Extracted addr0: $addr0"
echo "Extracted seed for import."

# --- User Input (Second Run) ---
read -sp "Enter second password: " second_password
echo ""

# --- Run vcli (Second Run: Import Seed) ---
echo "Starting second run with imported seed..."
{
  echo "$extracted_seed"
} | ./vcli "$second_password" 2>&1 | tee vcli2_output.log > /dev/null &
vcli2_pid=$!

echo "Waiting for seed generation (second run)..."
while true; do
    if grep -q "$TARGET_LINE" vcli2_output.log; then
        echo "Second seed generation complete."
        break
    fi
    sleep 1
done

addr1=$(grep "generates address" vcli2_output.log | head -n1 | sed -E 's/.*generates address ([^ ]+).*/\1/')
echo "Extracted addr1: $addr1"

kill $vcli2_pid
echo "Second run terminated."

# --- Create valis.conf ---
read -p "Enter your public IP address: " ipaddr
read -p "Do you want to enable zerobind (zerobind is needed in some home or AWS setups)? (yes/no): " zerobind_choice
read -p "Enter your Infura project ID (create one at https://developer.metamask.io/): " infura_project_id

if [[ "$zerobind_choice" =~ ^[Yy] ]]; then
    zerobind_line="zerobind"
else
    zerobind_line=""
fi

cat <<EOF > valis.conf
pw0 $password
addr0 $addr0
pw1 $second_password
addr1 $addr1

ipaddr $ipaddr

$zerobind_line

infura $infura_project_id
EOF

echo "Configuration file valis.conf created."
echo "------------------------------------------------"
cat valis.conf
echo "------------------------------------------------"

# --- Clean Up Temporary Log Files ---
rm -f vcli_output.log vcli2_output.log
echo "Temporary log files removed."
echo "Script completed successfully."
