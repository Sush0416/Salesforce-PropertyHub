trigger PropertyApproval on Property__c (before update, after update) {
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        // Phase 4: Validation (could also be a Validation Rule)
        for (Property__c newProp : Trigger.new) {
            Property__c oldProp = Trigger.oldMap.get(newProp.Id);
            // Validate before allowing submission
            if (newProp.Approval_Status__c == Constants.PROPERTY_STATUS_SUBMITTED && 
                oldProp.Approval_Status__c == Constants.PROPERTY_STATUS_DRAFT) {
                if (newProp.Price__c == null || newProp.Price__c <= 0) {
                    newProp.addError('Price must be greater than 0 before submitting for approval.');
                }
            }
        }
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        // Phase 5: Process Automation
        // 1. Submit records that are newly 'Submitted' to the approval process
        PropertyApprovalHandler.submitForApproval(Trigger.new);
        
        // 2. Handle the result of approvals (e.g., if a process approved it)
        PropertyApprovalHandler.handleApprovalResult(Trigger.new, Trigger.oldMap);
    }
}