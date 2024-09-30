#!/bin/bash

# PostgreSQL command setup
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Prompt for the username
echo "Enter your username:"
read USERNAME

# Check if the username exists in the database
USER_DATA=$($PSQL "SELECT user_id, games_played, best_game FROM details WHERE username='$USERNAME'")

# If the user exists, welcome them back
if [[ -n $USER_DATA ]]; then
  IFS="|" read USER_ID GAMES_PLAYED BEST_GAME <<< "$USER_DATA"
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
else
  # If the user does not exist, insert a new row
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER_RESULT=$($PSQL "INSERT INTO details(username, games_played, best_game) VALUES('$USERNAME', 0, 1000)")
  USER_ID=$($PSQL "SELECT user_id FROM details WHERE username='$USERNAME'")
  GAMES_PLAYED=0
  BEST_GAME=1000
fi

# Generate random number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

# Initialize guess count
NUMBER_OF_GUESSES=0

# Start guessing game loop
while true; do
  echo "Guess the secret number between 1 and 1000:"
  read GUESS

  # Check if the guess is an integer
  if ! [[ "$GUESS" =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  ((NUMBER_OF_GUESSES++))

  # Compare guess to secret number
  if [[ $GUESS -lt $SECRET_NUMBER ]]; then
    echo "It's higher than that, guess again:"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]; then
    echo "It's lower than that, guess again:"
  else
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    
    # Increment the number of games played
    GAMES_PLAYED=$((GAMES_PLAYED + 1))

    # Check if this game is the new best game (fewer guesses)
    if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]]; then
      BEST_GAME=$NUMBER_OF_GUESSES
      # Update best_game in the database
      UPDATE_RESULT=$($PSQL "UPDATE details SET best_game=$BEST_GAME WHERE user_id=$USER_ID")
    fi

    # Update the number of games played in the database
    UPDATE_RESULT=$($PSQL "UPDATE details SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID")

    # Exit the game loop
    break
  fi
done
