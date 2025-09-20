public class NotificationService {
    
    public static void sendVisitConfirmation(Id visitId) {
        Property_Visit__c visit = [SELECT Id, Visitor_Name__c, Visitor_Email__c, 
                                  Visit_Date__c, Property__r.Name, Property__r.Address__c 
                                  FROM Property_Visit__c WHERE Id = :visitId];
        
        if (visit.Visitor_Email__c != null) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{visit.Visitor_Email__c});
            email.setSubject('Property Visit Confirmation: ' + visit.Property__r.Name);
            email.setPlainTextBody('Dear ' + visit.Visitor_Name__c + ',\n\n' +
                                 'Your visit has been confirmed for:\n' +
                                 'Property: ' + visit.Property__r.Name + '\n' +
                                 'Address: ' + visit.Property__r.Address__c + '\n' +
                                 'Date: ' + visit.Visit_Date__c.format() + '\n\n' +
                                 'Thank you for choosing PropertyHub!');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        }
    }
    
    public static void sendApprovalNotification(Id propertyId, String action) {
        Property__c prop = [SELECT Id, Name, OwnerId, Address__c, Price__c 
                           FROM Property__c WHERE Id = :propertyId];
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTargetObjectId(prop.OwnerId);
        email.setSaveAsActivity(false);
        email.setSubject('Property Approval ' + action + ': ' + prop.Name);
        email.setPlainTextBody('Your property ' + prop.Name + ' at ' + prop.Address__c + 
                              ' has been ' + action.toLowerCase() + '.\n' +
                              'Price: $' + prop.Price__c + '\n\n' +
                              'Thank you for using PropertyHub.');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
    }
}