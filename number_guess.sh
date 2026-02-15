#!/bin/bash

# Number Guessing Game Script
# This script generates a random number between 1 and 1000 for users to guess
# It tracks user statistics including games played and best game (fewest guesses)

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Function to execute database queries
function query_db() {
  local query="$1"
  local result=$($PSQL "$query" 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error: Unable to connect to database" >&2
    exit 1
  fi
  echo "$result"
}

# Generate a random number between 1 and 1000
SECRET_NUMBER=$((RANDOM % 1000 + 1))

# Initialize guess counter
NUMBER_OF_GUESSES=0

# Prompt for username
echo "Enter your username:"
read USERNAME

# Check if username exists in database
USER_DATA=$(query_db "SELECT games_played, best_game FROM users WHERE username = '$USERNAME';")

if [[ -z $USER_DATA ]]; then
  # New user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # Insert new user into database
  query_db "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 0, NULL);" > /dev/null
else
  # Returning user
  IFS="|" read GAMES_PLAYED BEST_GAME <<< "$USER_DATA"
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Guessing loop
echo "Guess the secret number between 1 and 1000:"

while true; do
  read GUESS
  
  # Check if input is an integer
  if ! [[ $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi
  
  # Validate guess is within the valid range
  if [[ $GUESS -lt 1 ]] || [[ $GUESS -gt 1000 ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi
  
  ((NUMBER_OF_GUESSES++))
  
  # Compare guess with secret number
  if [[ $GUESS -lt $SECRET_NUMBER ]]; then
    echo "It's higher than that, guess again:"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]; then
    echo "It's lower than that, guess again:"
  else
    # Correct guess!
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    
    # Update database
    # Get current best game for this user
    CURRENT_BEST=$(query_db "SELECT best_game FROM users WHERE username = '$USERNAME';")
    
    # Update the user's game statistics
    if [[ -z $CURRENT_BEST || $CURRENT_BEST == "NULL" || $NUMBER_OF_GUESSES -lt $CURRENT_BEST ]]; then
      NEW_BEST=$NUMBER_OF_GUESSES
    else
      NEW_BEST=$CURRENT_BEST
    fi
    
    NEW_GAMES=$(query_db "SELECT games_played FROM users WHERE username = '$USERNAME';" | cut -d'|' -f1)
    ((NEW_GAMES++))
    
    query_db "UPDATE users SET games_played = $NEW_GAMES, best_game = $NEW_BEST WHERE username = '$USERNAME';" > /dev/null
    
    break
  fi
done
