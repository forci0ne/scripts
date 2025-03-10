```
                                   
@@@  @@@ @@@  @@@  @@@@@@ @@@@@@@  
@@!  @@@ @@!  @@@ !@@     @@!  @@@ 
@!@  !@! @!@  !@!  !@@!!  @!@  !@! 
 !: .:!  !!:  !!!     !:! !!:  !!! 
   ::     :.:: :  ::.: :  :: :  :  
                                   
```

# 🚀 VALIS Node prepare Guide

Welcome to the **VALIS Node** preparation guide! Follow these steps to get your node up and running in no time. 🛰️

## 📌 Prerequisites
Make sure your system meets the following requirements:
- 🕒 Set system timezone to **UTC**
- 🛠️ Install required packages
- 📥 Download and run the installation script

## 🛠️ Installation Steps

### 1️⃣ Set Your Timezone to UTC
Ensure accurate timestamps for your node by setting your system’s timezone to **UTC**. You can verify your timezone at:
🌍 [Check UTC Time](https://time.is/UTC)

Run the following command:
```bash
dpkg-reconfigure tzdata
```

### 2️⃣ Download & Execute the VALIS Setup Script
Retrieve the script from GitHub:
```bash
wget https://raw.githubusercontent.com/forci0ne/scripts/refs/heads/main/prepare_valis.sh
```

Make the script executable:
```bash
chmod +x prepare_valis.sh
```

Run the script:
```bash
./prepare_valis.sh
```
⚠️ **Risk Disclaimer**
Running a node and managing private keys involve risks. We are not responsible for any potential loss of funds, misconfigurations, or security vulnerabilities arising from the use of this guide or the provided script. Use at your own risk and ensure you follow best security practices.

🚀 **Congratulations!** Your VALIS Node environment is now prepared. Please note that the node executables are not yet installed.

## 🛠️ What the Script Does

### 🔍 Pre-run Check
- The script asks if it has been run before.
- If yes, it cleans up previous configuration artifacts by removing the `valis/subseeds` directory and `valis.conf` file. Make sure to backup existing seeds if they are important.

### ⚙️ Environment Setup
- Creates the working directory (`valis`).
- Updates your system and installs required packages.
- Builds the `secp256k1` library if necessary.

### 📥 CLI Download
- Downloads the VALIS CLI executable (`vcli`) from GitHub.
- Makes it executable for usage.

### 🔑 First Run (Vanity Generator)
- Prompts for a password and a 3-letter vanity ID.
- Runs the CLI tool to generate seed data.
- Extracts important seed information once the output includes:
  ```
  Valis CLI Wallet address.
  ```
- Saves the seed as `seed1.bak`.

### 🔄 Second Run (Seed Import)
- Prompts for a second password.
- Imports the seed from `seed1.bak`.
- Runs the CLI tool again to extract the generated address.

### 📜 Configuration File Creation
- Asks for your public IP address.
- Prompts whether to enable `zerobind`.
- Requests your Infura project ID.
- Creates a `valis.conf` file with the provided configuration details.

### 🧹 Cleanup
- Removes temporary log files for a clean setup.
