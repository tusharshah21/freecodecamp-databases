# Periodic Table Database Project

A bash script that queries a PostgreSQL database to retrieve information about chemical elements.

## Overview

This project demonstrates how to interact with a PostgreSQL database using bash scripts. It provides a command-line interface to look up element information from the periodic table.

## Getting Started

### Prerequisites
- PostgreSQL installed and running
- Bash shell
- The periodic_table database configured with freecodecamp user

### Database Connection

Connection string:
```bash
psql --username=freecodecamp --dbname=periodic_table
```

## Usage

The script accepts an element identifier as an argument:

```bash
# Query by atomic number
./element.sh 1

# Query by element symbol
./element.sh H

# Query by element name
./element.sh Hydrogen
```

### Output

For a valid element, the script outputs:
```
The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
```

### Error Handling

- **No argument:** `Please provide an element as an argument.`
- **Element not found:** `I could not find that element in the database.`

## Database Schema

### Tables

#### elements
- `atomic_number` (INTEGER, PRIMARY KEY)
- `symbol` (VARCHAR(2), NOT NULL, UNIQUE)
- `name` (VARCHAR(40), NOT NULL, UNIQUE)

#### properties
- `atomic_number` (INTEGER, FOREIGN KEY, PRIMARY KEY)
- `atomic_mass` (DECIMAL)
- `melting_point_celsius` (NUMERIC, NOT NULL)
- `boiling_point_celsius` (NUMERIC, NOT NULL)
- `type_id` (INTEGER, FOREIGN KEY, NOT NULL)

#### types
- `type_id` (INTEGER, PRIMARY KEY)
- `type` (VARCHAR(30), NOT NULL)

## Testing

Run the included test script:
```bash
./test.sh
```

## Files

- `element.sh` - Main query script
- `test.sh` - Automated test suite
- `periodic_table.sql` - Database backup and schema
- `README.md` - This file
- `.gitignore` - Git configuration

## Supported Elements

The database contains information for elements 1-10:
1. Hydrogen (H)
2. Helium (He)
3. Lithium (Li)
4. Beryllium (Be)
5. Boron (B)
6. Carbon (C)
7. Nitrogen (N)
8. Oxygen (O)
9. Fluorine (F)
10. Neon (Ne)
