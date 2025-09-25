trigger PropertyVisitTrigger on Property_Visit__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            VisitScheduler.scheduleVisits(Trigger.new);
        }
        
        if (Trigger.isInsert || Trigger.isUpdate) {
            VisitScheduler.sendVisitConfirmation(Trigger.new);
        }
    }
}