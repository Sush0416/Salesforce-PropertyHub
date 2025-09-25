public with sharing class PropertyApprovalHandler {
    
    // This method ONLY submits records to the approval process.
    // It assumes the record has already been validated and its status set to 'Submitted'.
    public static void submitForApproval(List<Property__c> properties) {
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        
        for (Property__c prop : properties) {
            // Check if it's in the right status to be submitted
            if (prop.Approval_Status__c == Constants.PROPERTY_STATUS_SUBMITTED) {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(prop.Id);
                req.setComments('Submitting property for approval: ' + prop.Name);
                requests.add(req);
            }
        }
        
        if (!requests.isEmpty()) {
            try {
                List<Approval.ProcessResult> results = Approval.process(requests);
                // Optional: Log results or handle errors here
            } catch (Exception e) {
                // Handle exception gracefully, e.g., log it or create a task for admin
                System.debug('Error submitting for approval: ' + e.getMessage());
                // You could also use addError on the records if needed
            }
        }
    }
    
    // This method is called from a AFTER UPDATE trigger.
    // It checks the old and new values to see if the record was just approved/rejected via the Process.
    public static void handleApprovalResult(List<Property__c> newProperties, Map<Id, Property__c> oldMap) {
        List<Property__c> approvedProperties = new List<Property__c>();
        List<Property__c> rejectedProperties = new List<Property__c>();

        for (Property__c newProp : newProperties) {
            Property__c oldProp = oldMap.get(newProp.Id);

            // Check if the status was changed TO 'Approved' FROM 'Submitted'
            if (newProp.Approval_Status__c == Constants.PROPERTY_STATUS_APPROVED && oldProp.Approval_Status__c == Constants.PROPERTY_STATUS_SUBMITTED) {
                approvedProperties.add(newProp);
            }
            // Check if the status was changed TO 'Rejected' FROM 'Submitted'
            if (newProp.Approval_Status__c == Constants.PROPERTY_STATUS_REJECTED && oldProp.Approval_Status__c == Constants.PROPERTY_STATUS_SUBMITTED) {
                rejectedProperties.add(newProp);
            }
        }

        // Process approved properties
        for (Property__c prop : approvedProperties) {
            prop.Status__c = Constants.PROPERTY_AVAILABLE;
            prop.Last_Approval_Date__c = System.today();
            // Add any other post-approval logic here
        }

        // Process rejected properties
        // You could add specific logic for rejected properties here if needed
        // for (Property__c prop : rejectedProperties) { ... }

        // Notify relevant users
        if (!approvedProperties.isEmpty() || !rejectedProperties.isEmpty()) {
            notifyApprovers(approvedProperties, rejectedProperties);
        }
    }

    // Overload for single property
    public static void handleApprovalResult(Property__c newProp, Property__c oldProp) {
        handleApprovalResult(new List<Property__c>{newProp}, new Map<Id, Property__c>{newProp.Id => oldProp});
    }
    
    // Bulkified email notification method
    public static void notifyApprovers(List<Property__c> approvedProps, List<Property__c> rejectedProps) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Set<Id> userIds = new Set<Id>();
        
        // Collect user IDs (this is a simple example - you might have a specific approver field)
        for (Property__c prop : approvedProps) {
            userIds.add(prop.OwnerId);
        }
        for (Property__c prop : rejectedProps) {
            userIds.add(prop.OwnerId);
        }
        
        // Map to get user emails
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Email FROM User WHERE Id IN :userIds]);
        
        // Create emails for approved properties
        for (Property__c prop : approvedProps) {
            User propOwner = userMap.get(prop.OwnerId);
            if (propOwner != null && propOwner.Email != null) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{ propOwner.Email });
                email.setSubject('Property Approved: ' + prop.Name);
                email.setPlainTextBody('Congratulations! Your property has been approved.\n' +
                                      'Property: ' + prop.Name + '\n' +
                                      'Address: ' + prop.Address__c + '\n' +
                                      'Price: $' + prop.Price__c);
                emails.add(email);
            }
        }
        
        // Create emails for rejected properties (similar logic)
        for (Property__c prop : rejectedProps) {
            // ... build rejection emails ...
        }
        
        // Send all emails at once
        if (!emails.isEmpty()) {
            try {
                Messaging.sendEmail(emails);
            } catch (EmailException e) {
                System.debug('Email sending failed: ' + e.getMessage());
            }
        }
    }
}