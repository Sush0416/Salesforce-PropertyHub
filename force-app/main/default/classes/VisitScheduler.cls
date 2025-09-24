public class VisitScheduler {
    
    public static void scheduleVisits(List<Property_Visit__c> visits) {
        // Tumhara existing scheduling logic
    }
    
    public static void sendVisitConfirmation(List<Property_Visit__c> visits) {
        // Pehle valid values check karo
        Set<String> validStatuses = getValidStatusValues();
        
        for(Property_Visit__c visit : visits) {
            // Debug add karo
            System.debug('Processing Visit - Status: ' + visit.Status__c);
            
            // Check karo status valid hai aur Scheduled hai
            if(visit.Status__c != null && 
               validStatuses.contains(visit.Status__c) && 
               visit.Status__c == 'Scheduled') {
                
                if(visit.Phone__c != null) {
                    try {
                        // SMS send karo
                        SMSService.sendSMS(visit.Phone__c, 
                            'Your property visit is scheduled for ' + visit.Visit_Date__c);
                        System.debug('SMS sent successfully for visit: ' + visit.Id);
                    } catch(Exception e) {
                        System.debug('SMS failed: ' + e.getMessage());
                    }
                }
            } else {
                System.debug('Skipping visit - Invalid status: ' + visit.Status__c);
            }
        }
    }
    
    private static Set<String> getValidStatusValues() {
        Set<String> validValues = new Set<String>();
        List<Schema.PicklistEntry> ple = Property_Visit__c.Status__c.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry p : ple) {
            validValues.add(p.getValue());
        }
        return validValues;
    }
}