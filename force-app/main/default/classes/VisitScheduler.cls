public class VisitScheduler {
    
    public static void scheduleVisits(List<Property_Visit__c> newVisits) {
        // Check for scheduling conflicts
        Set<Id> propertyIds = new Set<Id>();
        Set<Date> visitDates = new Set<Date>();
        
        for (Property_Visit__c visit : newVisits) {
            propertyIds.add(visit.Property__c);
            visitDates.add(visit.Visit_Date__c);
        }
        
        // Get existing visits for the same properties and dates
        Map<String, Property_Visit__c> existingVisits = new Map<String, Property_Visit__c>();
        for (Property_Visit__c existing : [
            SELECT Id, Property__c, Visit_Date__c, Visit_Time__c 
            FROM Property_Visit__c 
            WHERE Property__c IN :propertyIds 
            AND Visit_Date__c IN :visitDates
        ]) {
            String key = existing.Property__c + '-' + existing.Visit_Date__c + '-' + existing.Visit_Time__c;
            existingVisits.put(key, existing);
        }
        
        // Check for conflicts and set status
        for (Property_Visit__c visit : newVisits) {
            String key = visit.Property__c + '-' + visit.Visit_Date__c + '-' + visit.Visit_Time__c;
            if (existingVisits.containsKey(key)) {
                visit.addError('A visit already exists for this property at the same date and time.');
            } else {
                visit.Status__c = 'Scheduled';
            }
        }
    }
    
    public static void sendVisitConfirmation(List<Property_Visit__c> newVisits) {
        // This would integrate with Email Service to send confirmations
        for (Property_Visit__c visit : newVisits) {
            if (visit.Status__c == 'Scheduled' && visit.Visitor_Email__c != null) {
                // Email sending logic would go here
                System.debug('Sending confirmation email to: ' + visit.Visitor_Email__c);
            }
        }
    }
}