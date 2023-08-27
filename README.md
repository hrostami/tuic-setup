# TUIC Auto Setup

This script automates setting up a TUIC server on Linux according to [iSegaro's tutorial](https://telegra.ph/How-to-start-the-TUIC-v5-protocol-with-iSegaro-08-26)

## Usage

To use the script:

1. Run this command to download and run the script
   ```
   
   curl -o tuic-setup.sh https://raw.githubusercontent.com/hrostami/tuic-setup/master/setup.sh && sudo bash tuic-setup.sh
   
   ```
2. Follow the prompts to enter a port number, password and congestion_control

3. The script will install dependencies, generate certs, create a config, and start the TUIC service

4. Your TUIC credentials and server info will be printed at the end
   
5. Run this command to manage the service
   ```
   tuic
   ```
   -Service Status
   -Restart Service
   -Add New User
   -List All Users
   -Delete User
   -Get config url
