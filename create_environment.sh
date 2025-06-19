#!/bin/bash

# stop script if anything goes wrong
set -e

# Prompt for user name
echo "Enter your name:"
read user_name

# This one make sure the user_name is not empty
if [[ -z "$user_name" ]]; then
    echo "Error: Name cannot be empty"
    exit 1
fi

# create the main directory
dir_name="submission_reminder_${user_name}"

# if directory already exists, you will be ask if you want to overwrite
if [[ -d "$dir_name" ]]; then
    echo "Directory '$dir_name' already exists."
    read -p "Do you want to overwrite it? (y/N): " overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled"
        exit 1
    fi
    rm -rf "$dir_name"
fi

# create the main folder and subfolders
mkdir -p "$dir_name"/{config,scripts,data}

# create config file
cat <<EOF > "$dir_name/config/config.env"
# just basic settings for the assignment checker
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# create the main functions file
cat <<'EOF' > "$dir_name/scripts/functions.sh"
#!/bin/bash

# find and load the config file
config_file="$(dirname "$0")/../config/config.env"

# check if config file exists
if [[ ! -f "$config_file" ]]; then
    echo "Error: Configuration file not found"
    exit 1
fi

# load the settings
source "$config_file"

# main function to check who hasn't submitted
function check_submissions {
    local submissions_file="$1"
    
    # make sure the submissions file exists
    if [[ ! -f "$submissions_file" ]]; then
        echo "Error: Submissions file not found"
        return 1
    fi
    
    # show what we're checking
    echo "Assignment: $ASSIGNMENT"
    echo "Days remaining to submit: $DAYS_REMAINING days"
    echo "--------------------------------------------"
    echo "Checking submissions in $submissions_file"
    
    # keep track of whether we found anyone who hasn't submitted
    local found_pending=false
    local line_num=0
    
    # read through each line of the CSV file
    while IFS=',' read -r student assignment status; do
        line_num=$((line_num + 1))
        
        # skip the header row
        if [[ $line_num -eq 1 ]]; then
            continue
        fi
        
        # remove extra spaces from each field
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)
        
        # skip if the line is empty
        if [[ -z "$student" ]]; then
            continue
        fi
        
        # check if this student hasn't submitted the current assignment
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
            found_pending=true
        fi
    done < "$submissions_file"
    
    # if nobody is missing submissions, say so
    if [[ "$found_pending" == false ]]; then
        echo "All students have submitted their assignments!"
    fi
}
EOF

# create the reminder script that calls our function
cat <<'EOF' > "$dir_name/scripts/reminder.sh"
#!/bin/bash
# load our functions and run the check
source "$(dirname "$0")/functions.sh"
check_submissions "$(dirname "$0")/../data/submissions.txt"
EOF

# create the startup script
cat <<'EOF' > "$dir_name/startup.sh"
#!/bin/bash
# get the directory where this script is located
SCRIPT_DIR="$(dirname "$0")"
# make sure all our scripts can be executed
chmod +x "$SCRIPT_DIR"/scripts/*.sh
# run the reminder check
"$SCRIPT_DIR"/scripts/reminder.sh
EOF

# create sample data file with some test students
cat <<EOF > "$dir_name/data/submissions.txt"
student,assignment,submission status
Chinemerem,Shell Navigation,not submitted
Chiagoziem,Git,submitted
Divine,Shell Navigation,not submitted
Anissa,Shell Basics,submitted
EOF

# create helper script to change assignments
cat <<'EOF' > "copilot_shell_script.sh"
#!/bin/bash

# stop if anything goes wrong
set -e

# get the user's name
echo "Enter your name:"
read user_name

# make sure they entered something
if [[ -z "$user_name" ]]; then
    echo "Error: Name cannot be empty"
    exit 1
fi

# check if their directory exists
user_dir="submission_reminder_${user_name}"
if [[ ! -d "$user_dir" ]]; then
    echo "Error: Directory '$user_dir' does not exist"
    echo "Please run the main setup script first"
    exit 1
fi

# ask for new assignment name
read -p "Enter new assignment name: " new_assignment

# make sure they entered something
if [[ -z "$new_assignment" ]]; then
    echo "Error: Assignment name cannot be empty"
    exit 1
fi

# find the config file
config_file="$user_dir/config/config.env"
if [[ ! -f "$config_file" ]]; then
    echo "Error: Configuration file not found"
    exit 1
fi

# update the assignment name in the config file
sed -i.bak "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$config_file"
rm -f "$config_file.bak"

# let them know it worked and run the check
echo "Assignment updated to: $new_assignment"
bash "$user_dir/startup.sh"
EOF

# make all the scripts runnable
chmod +x "$dir_name"/scripts/*.sh
chmod +x "$dir_name/startup.sh"
chmod +x copilot_shell_script.sh

# tell the user what to do next
echo "Setup complete."
echo "Run './$dir_name/startup.sh' to check reminders."
echo "Run './copilot_shell_script.sh' to change assignment and re-check."
