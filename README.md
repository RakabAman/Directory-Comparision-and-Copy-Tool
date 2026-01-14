Directory Comparison and Copy Tool
📌 Short Description
A PowerShell-based GUI tool for comparing and copying files between directories with support for skip lists.

📝 Overview
This project provides a Windows Forms GUI built with PowerShell to simplify directory comparison and file copying. It allows users to:

Select a source directory

Select a destination directory

Provide a skip list file containing paths to exclude

View real-time logs of skipped and copied files in an output box

The tool ensures files are copied only if they don’t already exist in the destination, while respecting the skip list.

🚀 Features
Graphical User Interface (GUI): Built using System.Windows.Forms for ease of use.

Browse Buttons: Quickly select source, destination, and skip list files.

Skip List Support: Exclude specific files or folders from being copied.

Real-Time Logging: Output box shows skipped, copied, and existing files.

Safe Copying: Prevents overwriting existing files in the destination.

📂 How It Works
Launch the script in PowerShell.

Use the Browse buttons to select:

Source directory

Destination directory

Skip list file (plain text file with paths to skip)

Click Start Copy to begin.

Monitor progress in the output box.

🛠️ Requirements
Windows OS

PowerShell 5.1 or later

.NET Framework (for Windows Forms)

▶️ Usage
Run the script in PowerShell:

powershell
.\DirectoryCopyTool.ps1
📑 Example Skip List
The skip list file should contain relative paths to exclude. Example:

Code
\Documents\old_report.docx
\Images\archive\
📜 License
