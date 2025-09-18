// force-app/main/default/classes/PropertyApprovalHandler.cls
public with sharing class PropertyApprovalHandler {
    public static void submitForApproval(List<Property__c> properties) {
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        List<Property__c> propsToUpdate = new List<Property__c>();
        for (Property__c prop : properties) {
            if (prop.Approval_Status__c == 'Draft' && prop.Price__c > 0) {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(prop.Id);
                req.setComments('Submitting property for approval: ' + prop.Name);
                requests.add(req);
                prop.Approval_Status__c = 'Submitted';
                propsToUpdate.add(prop);
            }
        }
        if (!requests.isEmpty()) {
            List<Approval.ProcessResult> results = Approval.process(requests);
            update propsToUpdate;
        }
    }
    public static void handleApprovalResult(List<Property__c> properties) {
        List<Property__c> propsToUpdate = new List<Property__c>();
        for (Property__c prop : properties) {
            if (prop.Approval_Status__c == 'Approved') {
                prop.Last_Approval_Date__c = Date.today();
                prop.Status__c = 'Available';
                propsToUpdate.add(prop);
            }
        }
        if (!propsToUpdate.isEmpty()) {
            update propsToUpdate;
        }
    }
}