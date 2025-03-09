```
                                   
@@@  @@@ @@@  @@@  @@@@@@ @@@@@@@  
@@!  @@@ @@!  @@@ !@@     @@!  @@@ 
@!@  !@! @!@  !@!  !@@!!  @!@  !@! 
 !: .:!  !!:  !!!     !:! !!:  !!! 
   ::     :.:: :  ::.: :  :: :  :  
                                   
```

# 🚀 VALIS Node prepare Guide

Welcome to the **VALIS Node** installation guide! Follow these steps to get your node up and running in no time. 🛰️

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

### 2️⃣ Install Git (if not already installed)
If Git is missing, install it using:
```bash
apt install git
```
If the command fails, try:
```bash
sudo apt install git
```

### 3️⃣ Download & Execute the VALIS Setup Script
Retrieve the script from GitHub:
```bash
wget https://github.com/forci0ne/scripts/blob/main/prepare_valis.sh
```

Make the script executable:
```bash
chmod +x prepare_valis.sh
```

Run the script:
```bash
./prepare_valis.sh
```

---
🚀 **Congratulations!** Your VALIS Node environment is now prepared.

