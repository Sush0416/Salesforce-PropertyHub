public with sharing class NotificationService {
    public static void sendVisitConfirmation(String visitId) {
        try {
            Property_Visit__c visit = [SELECT Id, Visitor_Name__c, Visitor_Email__c, Visit_Date__c, Visit_Time__c, Property__r.Name, Property__r.Address__c FROM Property_Visit__c WHERE Id = :visitId];
            if (visit.Visitor_Email__c != null) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{visit.Visitor_Email__c});
                email.setSubject('Property Visit Confirmation: ' + visit.Property__r.Name);
                String emailBody = 'Dear ' + visit.Visitor_Name__c + ',\n\n' +
                                   'Your property visit has been confirmed for:\n' +
                                   'Property: ' + visit.Property__r.Name + '\n' +
                                   'Address: ' + visit.Property__r.Address__c + '\n' +
                                   'Date: ' + visit.Visit_Date__c + '\n' +
                                   'Time: ' + visit.Visit_Time__c + '\n\n' +
                                   'Please arrive 10 minutes before your scheduled time.\n\n' +
                                   'Thank you for choosing PropertyHub!\n\n' +
                                   'Best regards,\nThe PropertyHub Team';
                email.setPlainTextBody(emailBody);
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
            }
        } catch (Exception e) {
            System.debug('Error sending visit confirmation: ' + e.getMessage());
        }
    }
    
    public static void sendApprovalNotification(String propertyId, String status) {
        try {
            Property__c prop = [SELECT Id, Name, OwnerId, Address__c, Price__c FROM Property__c WHERE Id = :propertyId];
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(prop.OwnerId);
            email.setSaveAsActivity(false);
            email.setSubject('Property Approval ' + status + ': ' + prop.Name);
            email.setPlainTextBody('Your property ' + prop.Name + ' at ' + prop.Address__c + ' has been ' + status.toLowerCase() + '.\n' +
                                   'Price: $' + prop.Price__c + '\n\n' +
                                   'Thank you for using PropertyHub.');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        } catch (Exception e) {
            System.debug('Error sending approval notification: ' + e.getMessage());
        }
    }
}