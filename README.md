# Adreno Magisk Driver Builder

This repository contains a bash script that simplifies the process of downloading and installing proprietary Adreno drivers for your device. The script provides several options to customize the driver implementation based on the vendor, device model/codename, and branch to download the libraries from.

## Prerequisites

Before running the script, ensure that you have the following prerequisites installed on your system:

- Bash (version 4.0 or above)
- curl (for downloading the driver libraries)

## Usage

To use the Adreno Magisk Driver Builder script, follow these steps:

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/pedrozzz0/adreno-magisk-builder
   ```

2. Change to the repository's directory:

   ```bash
   cd adreno-magisk-builder
   ```

3. Make the script executable:

   ```bash
   chmod +x adreno_builder.sh
   ```

4. Run the script with the required arguments.

   - [vendor] [$1]: Specifies the vendor of the device. This option is required.
   - [model] [$2]: Specifies the device model or codename. This option is required.
   - [branch] [$3]: Specifies the branch to download from. This option is also required.

   Example usage:

   ```bash
   ./adreno_builder.sh <vendor_name> <device_model> <branch_name>
   ```
   or
   ```bash
   sh adreno_builder.sh <vendor_name> <device_model> <branch_name>
   ```

   Replace `<vendor_name>` with the appropriate vendor (e.g., Samsung), `<device_model>` with the specific model or codename of the device, and `<branch_name>` with the desired branch name. Please note that the source for the libraries is [Android Dumps](https://dumps.tadiphone.dev/dumps) so you may need to check it out to find the devices and branches available.

## Disclaimer

The Adreno Magisk Driver Builder script is provided as-is and without any warranty. Use it at your own risk. The script relies on the availability and compatibility of Adreno drivers, which may vary based on different factors. The author of this script is not responsible for any damages or issues that may arise from the use of this script or the installed drivers.

## Contributing

If you encounter any issues or would like to contribute to the script, feel free to open an issue or submit a pull request in this repository. Your feedback and contributions are highly appreciated.

## License

This repository is licensed under the [GPL 3.0](LICENSE). Feel free to modify and distribute the script according to the terms of this license.