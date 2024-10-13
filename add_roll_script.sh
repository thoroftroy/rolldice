#!/bin/bash

# Script path
SCRIPT_PATH="$HOME/.local/bin/rolldice.sh"

# Ensure ~/.local/bin exists
mkdir -p "$HOME/.local/bin"

# Write the roll script to ~/.local/bin/rolldice.sh
cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/bash

# Function to roll a die and return the result
roll_die() {
    local dice_count=$1
    local dice_size=$2
    local rolls=()
    local sum=0

    for ((i=0; i<dice_count; i++)); do
        roll=$(( (RANDOM % dice_size) + 1 ))
        rolls+=($roll)
        sum=$((sum + roll))
    done

    echo "${rolls[@]} $sum"
}

# Function to parse the dice expression and roll accordingly
parse_expression() {
    local expression=$1
    local total=0
    local total_rolls=0
    local all_rolls=()
    
    # Split by commas to handle multiple expressions
    IFS=',' read -ra terms <<< "$expression"

    for term in "${terms[@]}"; do
        if [[ "$term" =~ ^([0-9]*)d([0-9]+)$ ]]; then
            num_rolls=${BASH_REMATCH[1]:-1}  # Default to 1 if not specified
            dice_size=${BASH_REMATCH[2]}
            result=$(roll_die $num_rolls $dice_size)
            rolls=(${result[@]})
            roll_sum=${rolls[-1]}  # Last element is the sum
            unset 'rolls[-1]'      # Remove the last element (sum) to show rolls
            echo "$term: ${rolls[*]} => Total: $roll_sum"
            all_rolls+=("${rolls[@]}")
            total=$((total + roll_sum))
            total_rolls=$((total_rolls + num_rolls))
        elif [[ "$term" =~ ^[0-9]+$ ]]; then
            echo "$term: $term"
            total=$((total + term))
            total_rolls=$((total_rolls + 1))
            all_rolls+=("$term")
        else
            echo "Invalid input: $term"
            exit 1
        fi
    done

    # Calculate average
    if ((total_rolls > 0)); then
        average=$(echo "$total / $total_rolls" | bc -l)
    else
        average=0
    fi

    echo -e "\nGrand Total: $total"
    echo "Average Roll: $(printf "%.2f" "$average")"
}

# Check for input
if [[ $# -lt 1 ]]; then
    echo "Usage: rolldice <expression>"
    echo "Example: rolldice 3d6,2d10,5"
    exit 1
fi

# Call the parse_expression function with the input
parse_expression "$1"
EOF

# Make the script executable
chmod +x "$SCRIPT_PATH"

# Add aliases to .bashrc
if ! grep -q "alias roll=" "$HOME/.bashrc"; then
    echo "alias roll='$SCRIPT_PATH'" >> "$HOME/.bashrc"
    echo "alias rolldice='$SCRIPT_PATH'" >> "$HOME/.bashrc"
    echo "alias rd='$SCRIPT_PATH'" >> "$HOME/.bashrc"
    echo "Aliases added to .bashrc. Please run 'source ~/.bashrc' to reload."
else
    echo "Aliases already exist in .bashrc"
fi
