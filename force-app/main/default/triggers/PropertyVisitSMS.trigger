trigger PropertyVisitSMS on Property_Visit__c (after insert, after update) {
    
    // Pehle valid status values get karo
    Set<String> validStatuses = new Set<String>();
    List<Schema.PicklistEntry> ple = Property_Visit__c.Status__c.getDescribe().getPicklistValues();
    for(Schema.PicklistEntry p : ple) {
        if(p.isActive()) {
            validStatuses.add(p.getValue());
        }
    }
    
    System.debug('Valid Statuses: ' + validStatuses);
    
    List<Property_Visit__c> visitsToProcess = new List<Property_Visit__c>();
    
    for(Property_Visit__c visit : Trigger.new) {
        System.debug('Processing Visit - Status: ' + visit.Status__c);
        
        // Check karo status valid hai aur humare business logic ke hisaab sahi hai
        if(visit.Status__c != null && 
           validStatuses.contains(visit.Status__c) && 
           (visit.Status__c == 'Planned' || visit.Status__c == 'Confirmed')) {
            
            visitsToProcess.add(visit);
            System.debug('Adding to SMS list: ' + visit.Id);
        }
    }
    
    if(!visitsToProcess.isEmpty()) {
        SMSService.sendVisitConfirmation(visitsToProcess);
    }
}