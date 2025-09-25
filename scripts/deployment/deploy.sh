#!/bin/bash

# Salesforce PropertyHub Phase 8 Deployment Script
echo "Starting PropertyHub Phase 8 deployment..."

# Authenticate to Salesforce
echo "Authenticating to Salesforce..."
sf org login web -a PropertyHub-Prod

# Validate deployment
echo "Validating deployment..."
sf project deploy validate --target-org PropertyHub-Prod

# Run tests
echo "Running tests..."
sf apex run test --target-org PropertyHub-Prod --result-format human --code-coverage

# Deploy to production
echo "Deploying to production..."
sf project deploy start --target-org PropertyHub-Prod --wait 30

# Data migration
echo "Starting data migration..."
sf apex run --file scripts/DataMigrationHandler.apex

# Enable duplicate rules
echo "Enabling duplicate rules..."
sf org assign permset --name DuplicateRuleAdmin --target-org PropertyHub-Prod

# Deploy data management components
echo "Deploying data management components..."
sf project deploy start --source-dir force-app/main/default/lwc/dataManagementConsole --target-org PropertyHub-Prod --wait 10

# Deploy duplicate rules
echo "Deploying duplicate rules..."
sf project deploy start --source-dir force-app/main/default/duplicateRules --target-org PropertyHub-Prod --wait 10

# Run data validation
echo "Running data validation..."
sf apex run --file scripts/deployment/validate-data.apex --target-org PropertyHub-Prod

echo "Phase 8 deployment completed successfully!"
