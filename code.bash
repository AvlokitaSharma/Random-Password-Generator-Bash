#!/bin/bash

# Extended Random Password Generator Script

# Configuration
MIN_LENGTH=8
MAX_LENGTH=64
DEFAULT_LENGTH=12
CHARS="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#%&+"

# Function to generate a random password
generate_password() {
    local password_length="$1"
    local generated_password=$(cat /dev/urandom | tr -dc "$CHARS" | fold -w "$password_length" | head -n 1)
    echo "$generated_password"
}

# Function to check password strength
check_strength() {
    local password="$1"
    # Example strength check: length and presence of different character types
    if [[ ${#password} -lt $MIN_LENGTH ]]; then
        echo "Weak"
    elif ! [[ $password =~ [A-Z] ]] || ! [[ $password =~ [a-z] ]] || ! [[ $password =~ [0-9] ]] || ! [[ $password =~ [@#%&+] ]]; then
        echo "Medium"
    else
        echo "Strong"
    fi
}

# Main function
main() {
    local password_length="${1:-$DEFAULT_LENGTH}"

    # Validate length input
    if [[ ! $password_length =~ ^[0-9]+$ ]] || [[ $password_length -lt $MIN_LENGTH ]] || [[ $password_length -gt $MAX_LENGTH ]]; then
        echo "Error: Password length must be a number between $MIN_LENGTH and $MAX_LENGTH."
        exit 1
    fi

    echo "Generating a password of length $password_length..."

    # Generate password
    local new_password=$(generate_password "$password_length")
    local strength=$(check_strength "$new_password")

    echo "Generated Password: $new_password"
    echo "Password Strength: $strength"
}

# Generate multiple passwords if requested
generate_multiple() {
    local count="$1"
    local length="$2"

    for ((i=1; i<=count; i++)); do
        main "$length"
        echo "----------"
    done
}

# User interaction for customization
echo "Welcome to the Extended Random Password Generator!"
echo "How many passwords would you like to generate? (Default is 1): "
read -r count

# Default to 1 if no input
count=${count:-1}

echo "Enter desired password length ($MIN_LENGTH to $MAX_LENGTH, Default is $DEFAULT_LENGTH): "
read -r length

generate_multiple "$count" "$length"
