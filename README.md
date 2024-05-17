# Educational Batch Virus Script

## Overview
This Batch Virus script is created solely for educational purposes to aid researchers and security analysts in understanding the mechanics of batch scripting and malware behavior. It demonstrates various techniques used by malicious software, providing a safe environment for study and analysis.

## Disclaimer
**Warning:** This script is intended for educational use only. Running this script on a live system can cause damage or data loss. Use it only in a controlled, isolated environment, such as a virtual machine, and ensure no valuable data is at risk.

## Features
- **File Creation and Encryption**: Demonstrates how files can be created and encrypted to fill disk space.
- **Stealth Techniques**: Showcases methods to avoid detection by some antivirus programs.
- **System Information Gathering**: Illustrates how to gather and manipulate system information.

## Usage

### Setup:
1. Ensure you are using a virtual machine or an isolated environment.
2. Backup any important data.

### Execution:
1. Run the script by double-clicking the `test.bat` file or executing it from the command line.
2. Observe the script's behavior and analyze its impact on the system.

### Analysis:
1. Use security tools and monitoring software to study the script's actions.
2. Document your findings and understand the techniques used.

## Learning Objectives
- Understand the basics of batch scripting.
- Learn how malware can exploit system vulnerabilities.
- Gain insights into methods used by security software to detect and mitigate threats.

## Contribution
Contributions to enhance the educational value of this script are welcome. Please submit pull requests with detailed descriptions of the changes.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Acknowledgements
Special thanks to the security research community for their continuous efforts in improving cybersecurity.

## Math Formulas

### File Creation and Encryption
The script may use simple encryption algorithms to demonstrate how data can be encrypted and decrypted. One common example is the XOR cipher:

\[ \text{ciphertext} = \text{plaintext} \oplus \text{key} \]

where \( \oplus \) denotes the XOR operation. For decryption, the same operation is applied:

\[ \text{plaintext} = \text{ciphertext} \oplus \text{key} \]

### Disk Space Calculation
To calculate the amount of disk space filled by the script, you can use the formula:

\[ \text{Disk Space Used} = \text{Number of Files} \times \text{Size of Each File} \]

For example, if the script creates 1000 files each of 1MB, the total disk space used would be:

\[ 1000 \times 1\text{MB} = 1000\text{MB} \]

By providing this script, I aim to contribute to the education and preparedness of future security professionals. Use it responsibly and ethically.
