#!/bin/bash

# Data Backup Script
echo "Starting data backup..."

# Backup Leads
sf data export tree --plan scripts/backup/lead-backup.json --target-org PropertyHub-Prod

# Backup Properties
sf data export tree --plan scripts/backup/property-backup.json --target-org PropertyHub-Prod

# Backup custom objects
sf data export tree --plan scripts/backup/custom-objects-backup.json --target-org PropertyHub-Prod

echo "Backup completed successfully!"