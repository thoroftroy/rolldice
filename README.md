# Rolldice
A simple command line utility for rolling a dice

Installation
----------------
run git clone https://github.com/thoroftroy/rolldice.git

run add_roll_script.sh in your terminal by going to the directory it is downloaded in and running

chmod +x add_roll_script.sh

./add_roll_script.sh

source ~/.bashrc

Manual
----------------
Optionally you could also just download the rolldice.sh script and put it in your bash manually. 

Usage
----------------
Usage: rolldice [option] <expression>

Options:
  <expression>   Roll dice with specified dice notation (e.g., 3d6,2d10,5)
  flip [count]   Flip a coin the specified number of times and display results.
  help, -h       Show this help message and exit.

Examples:
  rolldice 3d6,2d10,5    # Rolls dice
  rolldice flip 3        # Flips a coin 3 times
