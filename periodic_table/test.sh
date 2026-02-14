#!/bin/bash

# Test script for element.sh

echo "Testing element.sh script..."
echo ""

echo "Test 1: No argument"
./element.sh 2>&1
echo ""

echo "Test 2: Query by atomic number (1)"
./element.sh 1
echo ""

echo "Test 3: Query by symbol (H)"
./element.sh H
echo ""

echo "Test 4: Query by name (Hydrogen)"
./element.sh Hydrogen
echo ""

echo "Test 5: Query Neon by number (10)"
./element.sh 10
echo ""

echo "Test 6: Query Fluorine by symbol (F)"
./element.sh F
echo ""

echo "Test 7: Non-existent element"
./element.sh Unknownium
echo ""

echo "All tests completed!"
