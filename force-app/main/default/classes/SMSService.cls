public class SMSService {
    
    public static void sendVisitConfirmation(List<Property_Visit__c> visits) {
        System.debug('=== SMSService.sendVisitConfirmation called ===');
        System.debug('Number of visits: ' + visits.size());

        for(Property_Visit__c visit : visits) {
            System.debug('Visit ID: ' + visit.Id);
            System.debug('Status: ' + visit.Status__c);
            System.debug('Phone: ' + visit.Phone__c);
            System.debug('Visit Date: ' + visit.Visit_Date__c);

            String message = 'Your property visit is scheduled for ' + visit.Visit_Date__c;
            System.debug('SMS Message: ' + message);
        }
    }

    public static void sendSMS(String phone, String message) {
        System.debug('=== SMSService.sendSMS called ===');
        System.debug('Phone: ' + phone);
        System.debug('Message: ' + message);
        // Add actual SMS sending logic here if needed
    }
}