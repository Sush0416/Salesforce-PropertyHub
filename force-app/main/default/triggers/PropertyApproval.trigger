trigger PropertyApproval on Property__c (before update, after update) {
    // Updated trigger for Phase 4
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Property__c newProp : Trigger.new) {
            Property__c oldProp = Trigger.oldMap.get(newProp.Id);
            if (newProp.Approval_Status__c == 'Submitted' && oldProp.Approval_Status__c == 'Draft') {
                if (newProp.Price__c == null || newProp.Price__c <= 0) {
                    newProp.addError('Price must be greater than 0 before submitting for approval.');
                }
            }
        }
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Property__c> propertiesForApproval = new List<Property__c>();
        for (Property__c newProp : Trigger.new) {
            Property__c oldProp = Trigger.oldMap.get(newProp.Id);
            if (newProp.Approval_Status__c == 'Submitted' && oldProp.Approval_Status__c == 'Draft') {
                propertiesForApproval.add(newProp);
            }
            if (newProp.Approval_Status__c == 'Approved' && oldProp.Approval_Status__c == 'Submitted') {
                PropertyApprovalHandler.handleApprovalResult(newProp, oldProp);
                NotificationService.sendApprovalNotification(newProp.Id, 'Approved');
            }
        }
        if (!propertiesForApproval.isEmpty()) {
            PropertyApprovalHandler.submitForApproval(propertiesForApproval);
        }
    }
}