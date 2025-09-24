trigger PropertyVisitTrigger on Property_Visit__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            VisitScheduler.scheduleVisits(Trigger.new);
        }
        
        // Only send confirmation for valid records
        if (Trigger.isInsert || Trigger.isUpdate) {
            // Filter karo valid status wale records
            List<Property_Visit__c> validVisits = new List<Property_Visit__c>();
            for(Property_Visit__c visit : Trigger.new) {
                if(visit.Status__c == 'Scheduled') {  // Sirf scheduled visits ke liye
                    validVisits.add(visit);
                }
            }
            
            if(!validVisits.isEmpty()) {
                VisitScheduler.sendVisitConfirmation(validVisits);
            }
        }
    }
}