# Salesforce Deployment Fix Plan

## Phase 1: Fix Apex Classes (Critical - Blocking Deployment)
- [x] Fix BusinessHoursSetup.cls - Remove direct BusinessHours insertion
- [x] Fix PropertyController.cls - Correct field names (Bedrooms__c → Bathrooms__c, Visit_DateTime__c → Visit_Date__c/Visit_Time__c)
- [x] Fix PropertyControllerTest.cls - Same field corrections
- [x] Fix PropertyApproval.trigger - Fix method call parameters

## Phase 2: Fix Metadata Issues
- [x] Fix CustomApplication XML parsing issue
- [x] Fix Layout related list field references
- [x] Fix CustomTab URL encoding key
- [x] Fix FlexiPages v64.0 compatibility
- [x] Fix PermissionSet unknown permissions

## Phase 3: Fix Component Issues
- [x] Create missing Lightning components (offerList, propertyFilter, visitList)
- [ ] Fix Aura component CSS selectors

## Testing
- [ ] Deploy fixed components
- [ ] Run tests to verify functionality
- [ ] Validate layouts and pages work correctly
