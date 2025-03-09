
Welcome to **VALIS Node Setup**! This repository contains a script to prepare your system for running the VALIS CLI Wallet.

## Overview

This script will:
- Set your system timezone to **UTC**.
- Install required packages (including Git).
- Download and run the VALIS CLI wallet setup script.
- Configure your VALIS node by generating seed data and creating a configuration file.

## Prerequisites

Before running the script, ensure:
- Your system timezone is set to **UTC** for accurate timestamps.
- Git is installed on your system.

## Instructions

### 1. Set Timezone to UTC

Set your system's timezone to UTC. Check the current UTC time [here](https://time.is/UTC) and run:

```bash
dpkg-reconfigure tzdata
