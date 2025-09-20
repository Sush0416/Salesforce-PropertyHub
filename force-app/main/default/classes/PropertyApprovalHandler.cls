public class PropertyApprovalHandler {
    
    public static void submitForApproval(List<Property__c> properties) {
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        List<Property__c> propsToUpdate = new List<Property__c>();
        
        for (Property__c prop : properties) {
            if (prop.Approval_Status__c == 'Draft' && prop.Price__c > 0) {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(prop.Id);
                req.setComments('Submitting property for approval: ' + prop.Name);
                requests.add(req);
                
                Property__c updatedProp = new Property__c(Id = prop.Id);
                updatedProp.Approval_Status__c = 'Submitted';
                propsToUpdate.add(updatedProp);
            }
        }
        
        if (!requests.isEmpty()) {
            List<Approval.ProcessResult> results = Approval.process(requests);
            update propsToUpdate;
        }
    }
    
    public static void handleApprovalResult(List<Property__c> properties, Map<Id, String> approvalResults) {
        List<Property__c> propsToUpdate = new List<Property__c>();
        
        for (Property__c prop : properties) {
            if (approvalResults.containsKey(prop.Id)) {
                String result = approvalResults.get(prop.Id);
                Property__c updatedProp = new Property__c(Id = prop.Id);
                
                if (result == 'Approved') {
                    updatedProp.Approval_Status__c = 'Approved';
                    updatedProp.Last_Approval_Date__c = Date.today();
                    updatedProp.Status__c = 'Available';
                } else if (result == 'Rejected') {
                    updatedProp.Approval_Status__c = 'Rejected';
                }
                propsToUpdate.add(updatedProp);
            }
        }
        
        if (!propsToUpdate.isEmpty()) {
            update propsToUpdate;
        }
    }
    
    public static void notifyApprovers(List<Property__c> properties) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (Property__c prop : properties) {
            if (prop.Approval_Status__c == 'Submitted') {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSubject('Property Approval Required: ' + prop.Name);
                email.setPlainTextBody('Please review and approve the property: ' + prop.Name + 
                                      '\nAddress: ' + prop.Address__c + 
                                      '\nPrice: $' + prop.Price__c);
                email.setTargetObjectId(UserInfo.getUserId());
                emails.add(email);
            }
        }
        
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}
