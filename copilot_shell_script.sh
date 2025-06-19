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
