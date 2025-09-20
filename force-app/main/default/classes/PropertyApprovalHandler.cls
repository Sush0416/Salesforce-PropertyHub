public with sharing class PropertyApprovalHandler {

    public static void submitForApproval(List<Property__c> properties) {
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        
        for (Property__c prop : properties) {
            if (prop.Approval_Status__c == 'Draft' && prop.Price__c != null && prop.Price__c > 0) {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(prop.Id);
                req.setComments('Submitting property for approval: ' + prop.Name);
                requests.add(req);
                
                prop.Approval_Status__c = 'Submitted';
            }
        }
        
        if (!requests.isEmpty()) {
            Approval.process(requests);
            update properties; // optional if you want to update Approval_Status__c in bulk
        }
    }

    public static void handleApprovalResult(List<Property__c> properties, Map<Id, String> approvalResults) {
        List<Property__c> toUpdate = new List<Property__c>();
        
        for (Property__c prop : properties) {
            if (approvalResults.containsKey(prop.Id)) {
                String result = approvalResults.get(prop.Id);
                
                if (result == 'Approved') {
                    prop.Approval_Status__c = 'Approved';
                    prop.Status__c = 'Available';
                } else if (result == 'Rejected') {
                    prop.Approval_Status__c = 'Rejected';
                }
                
                toUpdate.add(prop);
            }
        }
        
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    public static void notifyApprovers(List<Property__c> properties, Id approverId) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (Property__c prop : properties) {
            if (prop.Approval_Status__c == 'Submitted') {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSubject('Property Approval Required: ' + prop.Name);
                email.setPlainTextBody('Please review and approve the property: ' + prop.Name + 
                                       '\nAddress: ' + prop.Address__c + 
                                       '\nPrice: $' + prop.Price__c);
                email.setTargetObjectId(approverId); // Pass actual approver User Id
                email.setSaveAsActivity(false);
                emails.add(email);
            }
        }
        
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}