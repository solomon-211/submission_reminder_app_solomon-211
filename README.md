# Submission Reminder Application

This is a shell-based application that helps monitor students' assignment submissions.

## Features of the application
- Track students' submissions  
- Alert them of pending assignments and updates with upcoming deadlines  
- It ensures that all students submit their assignments  
- Alerts them of the upcoming deadlines  

## Application Overview

The submission reminder application helps student teachers keep track of who has submitted and who has not submitted their assignments while reminding them of the remaining days. 

### The Installation and Setup can be done by:

Cloning the repository to the local machine:

- bash
git clone https://github.com/yourusername/submission_reminder_app_yourusername.git
cd submission_reminder_app_yourusername

## Make Scripts Executable:
chmod +x create_environment.sh
chmod +x copilot_shell_script.sh

## Run the setup scripts:
./create_environment.sh

## When running the setup scripts:
- Prompts: Enter User name
- Creates a main directory named submission_reminder_yourname
- Make all folders and .sh files executable

## Checking submissions:
bash
./submission_reminder_username/startup.sh

- It displays the names of students who have not submitted their assignment
- Updates them on the remaining days to complete their assignments until the deadlines

## Checking non-submission status:

The Copilot script file is run:
./copilot_shell_script.sh

## What happens after running the copilot scripts file?
- Prompted the user to enter a username (Must match the initial username)
- Enter a new assignment name

## Then:
- Updates the assignment value in config/config.env using sed
- Display the confirmation message that all students have submitted their assignments

## Note:
 - When a mismatched username is entered, it shows an error message that the directory exists and asks to re-run the main scripts setup to enter a matched username to the initial setup

## Troubleshooting

1. Common Issues
"Directory already exists" error
- The scripts will ask if you want to overwrite the existing directory
- Select "y" to replace and "N" to cancel

2. "Configuration file not found."
- Ensure that you have run the create_environment.sh
- Proofread that your directory matches your inputs

3. "Submissions file not found."
- Validate data/submissions.txt exists in the environment
- Check file permissions and paths

## File permissions
 
If you encounter some permissions errors:
 Make sure all file scripts are executable to run

# Make all scripts executable:

chmod +x submission_reminder_yourname/scripts/*.sh
chmod +x submission_reminder_yourname/startup.sh


## Development project
# This project was developed using:

Bash scripting for automation and logic

- CSV data handling for student records
- Modular design with separate configuration and function file
- Git branching workflow for version control
- Development done on the feature/setup branch
- Final version merged to the main branch
- Only essential files are kept in the main branch

## Git Workflow & Submission Instructions

# Initial Repository Setup
Create a Repository on GitHub

Name should be: submission_reminder_app_YourGitHubUsername

# Clone and Initialize:

git clone https://github.com/yourusername/submission_reminder_app_yourusername.git
cd submission_reminder_app_yourusername

# Create Feature Branch:

git checkout -b feature/setup

Add Your Files to Feature Branch:
# Add the main scripts
git add create_environment.sh
git add copilot_shell_script.sh
git add README.md

# Commit your work
git commit -m "Add initial environment setup and copilot scripts"

# Push feature branch to GitHub
git push -u origin feature/setup

Test Your Scripts:
# Test the create_environment script
./create_environment.sh

# Test the copilot script
./copilot_shell_script.sh

# If I need to make improvements, add and commit them:
git add .
git commit -m "Fix script issues and improve functionality"
git push origin feature/setup

# Final Submission (Main Branch)
Switch to Main Branch:
git checkout main

Add Only Required Files to Main:
# Copy files from feature branch to main
git checkout feature/setup -- create_environment.sh
git checkout feature/setup -- copilot_shell_script.sh
git checkout feature/setup -- README.md

Final Commit and Push:
# Add the three required files: 
git add create_environment.sh copilot_shell_script.sh README.md

# Commit final submission
git commit -m "Final submission: Add environment setup, copilot script, and documentation"

# Push to main branch
git push origin main

