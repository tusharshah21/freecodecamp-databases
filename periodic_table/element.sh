#!/bin/bash

# Periodic Table Database Query Script
# Queries PostgreSQL database for element information by atomic number, symbol, or name
# Usage: ./element.sh <atomic_number|symbol|name>

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# SQL query template for element lookup with all required joins
QUERY="SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, 
       p.melting_point_celsius, p.boiling_point_celsius 
       FROM elements e 
       JOIN properties p ON e.atomic_number = p.atomic_number 
       JOIN types t ON p.type_id = t.type_id"

# Check if argument provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Query the database based on input type
if [[ $1 =~ ^[0-9]+$ ]]; then
  # Numeric input - query by atomic number
  RESULT=$($PSQL "$QUERY WHERE e.atomic_number = $1;")
elif [[ ${#1} -le 2 ]]; then
  # 1-2 character input - query by symbol
  RESULT=$($PSQL "$QUERY WHERE e.symbol = '$1';")
else
  # Longer input - query by name
  RESULT=$($PSQL "$QUERY WHERE e.name = '$1';")
fi

# Process and display results
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
else
  # Parse the query result
  IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"
  
  # Trim whitespace from all fields
  ATOMIC_NUMBER=$(echo "$ATOMIC_NUMBER" | xargs)
  NAME=$(echo "$NAME" | xargs)
  SYMBOL=$(echo "$SYMBOL" | xargs)
  TYPE=$(echo "$TYPE" | xargs)
  MASS=$(echo "$MASS" | xargs)
  MELTING=$(echo "$MELTING" | xargs)
  BOILING=$(echo "$BOILING" | xargs)
  
  # Display formatted element information
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi
