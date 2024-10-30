#!/bin/bash

# Function to roll a die and return the result with a small delay
roll_die() {
    local dice_count=$1
    local dice_size=$2
    local sum=0

    for ((i=0; i<dice_count; i++)); do
        roll=$(( (RANDOM % dice_size) + 1 ))
        echo "Roll $((i+1)): $roll"
        sum=$((sum + roll))
        sleep 0.0000000001  # Delay between each roll
    done

    echo "Total for $dice_count d$dice_size: $sum"
    average=$(echo "scale=2; $sum / $dice_count" | bc)  # Calculate average
    echo "Average roll: $average"  # Display average
    return $sum
}

# Function to parse the dice expression and roll accordingly with individual roll printing
parse_expression() {
    local expression=$1
    local total=0
    
    # Split by commas to handle multiple expressions
    IFS=',' read -ra terms <<< "$expression"

    for term in "${terms[@]}"; do
        if [[ "$term" =~ ^([0-9]*)d([0-9]+)$ ]]; then
            num_rolls=${BASH_REMATCH[1]:-1}  # Default to 1 if not specified
            dice_size=${BASH_REMATCH[2]}
            echo "Rolling $term:"
            roll_die $num_rolls $dice_size
            roll_sum=$?  # Get the total sum from the roll_die function
            total=$((total + roll_sum))
            echo "-----------------------------"
        elif [[ "$term" =~ ^[0-9]+$ ]]; then
            echo "$term: $term"
            total=$((total + term))
        else
            echo "Invalid input: $term"
            exit 1
        fi
    done

    echo -e "\nGrand Total: $total"
}

# Function to flip coins multiple times and display results with delay
flip_coin() {
    local num_flips=${1:-1}  # Default to 1 flip if no argument is provided
    local heads_count=0
    local tails_count=0
    
    for ((i=0; i<num_flips; i++)); do
        if (( RANDOM % 2 )); then
            echo "Flip $((i+1)): Heads"
            heads_count=$((heads_count + 1))
        else
            echo "Flip $((i+1)): Tails"
            tails_count=$((tails_count + 1))
        fi
        sleep 0.0000001  # Delay between each flip
    done

    # Calculate the average (heads as 1, tails as 0)
    average=$(echo "$heads_count / $num_flips" | bc -l)
    
    # Display results
    echo
    echo
    echo "Average roll (Heads as 1, Tails as 0): $(printf "%.2f" "$average")"
    echo "Total Heads: $heads_count"
    echo "Total Tails: $tails_count"
}

# Function to display help information
display_help() {
    echo "Usage: rolldice [option] <expression>"
    echo
    echo "Options:"
    echo "  <expression>   Roll dice with specified dice notation (e.g., 3d6,2d10,5)"
    echo "  flip [count]   Flip a coin the specified number of times and display results."
    echo "  help, -h       Show this help message and exit."
    echo
    echo "Examples:"
    echo "  rolldice 3d6,2d10,5    # Rolls dice"
    echo "  rolldice flip 3        # Flips a coin 3 times"
}

# Check input
if [[ $# -lt 1 ]]; then
    echo "Usage: rolldice [option] <expression>"
    echo "Type 'rolldice -h' or 'rolldice help' for more information."
    exit 1
fi

# Main logic to handle commands
case "$1" in
    flip)
        flip_coin "${2:-1}"  # Pass the second argument if provided, default to 1 flip
        ;;
    help|-h)
        display_help
        ;;
    *)
        if [[ "$1" =~ ^[0-9]*d[0-9]+(,[0-9]*d[0-9]+)*$ ]]; then
            parse_expression "$1"
        else
            echo "Invalid command. Type 'rolldice -h' or 'rolldice help' for more information."
        fi
        ;;
esac
