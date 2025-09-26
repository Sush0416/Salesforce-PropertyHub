@echo off
echo === Cleaning up previous deployment ===
if exist force-app\main\default\reports rmdir /s /q force-app\main\default\reports
if exist force-app\main\default\dashboards rmdir /s /q force-app\main\default\dashboards
if exist force-app\main\default\reportTypes rmdir /s /q force-app\main\default\reportTypes

echo === Creating proper folder structure ===
if not exist force-app\main\default\reports mkdir force-app\main\default\reports
if not exist force-app\main\default\dashboards mkdir force-app\main\default\dashboards
if not exist force-app\main\default\reportTypes mkdir force-app\main\default\reportTypes
if not exist force-app\main\default\objects\Property__c\sharingRules mkdir force-app\main\default\objects\Property__c\sharingRules

echo === Deploying in correct order ===
sfdx force:source:deploy -p force-app/main/default/objects -u sushmita.katariya.cs22257@agentforce.com
sfdx force:source:deploy -p force-app/main/default/reportTypes -u sushmita.katariya.cs22257@agentforce.com
sfdx force:source:deploy -p force-app/main/default/reports -u sushmita.katariya.cs22257@agentforce.com
sfdx force:source:deploy -p force-app/main/default/dashboards -u sushmita.katariya.cs22257@agentforce.com
sfdx force:source:deploy -p force-app/main/default/permissionsets -u sushmita.katariya.cs22257@agentforce.com

echo === Deployment complete ===
pause
