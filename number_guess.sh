#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Prompt for username
echo "Enter your username:"
read USERNAME

# Check if the username exists in the database
USER_INFO=$($PSQL "SELECT username, games_played, best_game FROM details WHERE username='$USERNAME'")

if [[ -z $USER_INFO ]]
then
  # If the user doesn't exist, add them to the database
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER=$($PSQL "INSERT INTO details(username, games_played) VALUES('$USERNAME', 0)")
else
  # If the user exists, retrieve and display their info
  echo "$USER_INFO" | while IFS="|" read USERNAME GAMES_PLAYED BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

# Generate the secret number
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESSES=0

# Start guessing loop
echo "Guess the secret number between 1 and 1000:"
while true
do
  read GUESS

  # Check if the guess is an integer
  if ! [[ $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    ((NUMBER_OF_GUESSES++))
    if [[ $GUESS -eq $SECRET_NUMBER ]]
    then
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

      # Update the user's stats in the database
      if [[ -z $USER_INFO ]]
      then
        UPDATE_STATS=$($PSQL "UPDATE details SET games_played = 1, best_game = $NUMBER_OF_GUESSES WHERE username='$USERNAME'")
      else
        USER_INFO=$($PSQL "SELECT games_played, best_game FROM details WHERE username='$USERNAME'")
        echo "$USER_INFO" | while IFS="|" read GAMES_PLAYED BEST_GAME
        do
          NEW_GAMES_PLAYED=$(( GAMES_PLAYED + 1 ))
          if [[ -z $BEST_GAME || $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
          then
            UPDATE_STATS=$($PSQL "UPDATE details SET games_played = $NEW_GAMES_PLAYED, best_game = $NUMBER_OF_GUESSES WHERE username='$USERNAME'")
          else
            UPDATE_STATS=$($PSQL "UPDATE details SET games_played = $NEW_GAMES_PLAYED WHERE username='$USERNAME'")
          fi
        done
      fi
      break
    elif [[ $GUESS -lt $SECRET_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
    else
      echo "It's lower than that, guess again:"
    fi
  fi
done
