trigger PropertyApprovalTrigger on Property__c (before update, after update) {
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Property__c newProp : Trigger.new) {
            Property__c oldProp = Trigger.oldMap.get(newProp.Id);
            
            if (newProp.Approval_Status__c == 'Submitted' && 
                oldProp.Approval_Status__c == 'Draft') {
                if (newProp.Price__c == null || newProp.Price__c <= 0) {
                    newProp.addError('Price must be greater than 0 before submitting for approval.');
                }
            }
        }
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Property__c> propertiesForApproval = new List<Property__c>();
        Map<Id, String> approvalResults = new Map<Id, String>();
        
        for (Property__c newProp : Trigger.new) {
            Property__c oldProp = Trigger.oldMap.get(newProp.Id);
            
            // Handle approval submissions
            if (newProp.Approval_Status__c == 'Submitted' && 
                oldProp.Approval_Status__c == 'Draft') {
                propertiesForApproval.add(newProp);
            }
            
            // Handle approval results
            if ((newProp.Approval_Status__c == 'Approved' || 
                 newProp.Approval_Status__c == 'Rejected') && 
                oldProp.Approval_Status__c == 'Submitted') {
                approvalResults.put(newProp.Id, newProp.Approval_Status__c);
            }
        }
        
        if (!propertiesForApproval.isEmpty()) {
            PropertyApprovalHandler.submitForApproval(propertiesForApproval);
        }
        
        if (!approvalResults.isEmpty()) {
            PropertyApprovalHandler.handleApprovalResult(Trigger.new, approvalResults);
        }
    }
}