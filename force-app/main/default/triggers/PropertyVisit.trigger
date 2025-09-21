trigger PropertyVisit on Property_Visit__c (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        PropertyVisitService.checkForSchedulingConflicts(Trigger.new);
    }
}