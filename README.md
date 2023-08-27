# TUIC Auto Setup

This script automates the process of setting up a TUIC server on a Linux system, following the guidelines provided in [iSegaro's tutorial](https://telegra.ph/How-to-start-the-TUIC-v5-protocol-with-iSegaro-08-26).

## Usage

To use the script, follow these steps:

1. **Download and Run the Script**: Execute the following command in your terminal to download and run the script:
   
   ```bash
   curl -o tuic-setup.sh https://raw.githubusercontent.com/hrostami/tuic-setup/master/setup.sh && sudo bash tuic-setup.sh
   ```

2. **Provide Information**: You will be prompted to provide the following information:
   - **Port Number**: Enter the port number you want the TUIC server to listen on.
   - **Password**: Set a password for the server to ensure secure access.
   - **Congestion Control**: Choose the desired congestion control option.

3. **Script Actions**:
   - The script will perform the following actions:
     - Install necessary dependencies.
     - Generate SSL certificates for secure communication.
     - Create a configuration file for the TUIC server.
     - Start the TUIC service.

4. **Server Information**: Once the setup is complete, your TUIC server credentials and server information will be displayed.

5. **Manage the Service**: Use the `tuic` command to manage the TUIC service. Available options include:
   - **Service Status**: Check the status of the TUIC service.
   - **Restart Service**: Restart the TUIC service if needed.
   - **Add New User**: Add a new user to the TUIC server.
   - **List All Users**: Display a list of all registered users.
   - **Delete User**: Remove a user from the TUIC server.
   - **Get Config URL**: Retrieve the URL for the configuration.

## Prerequisites

- A Linux system.
- The `curl` command-line tool.
