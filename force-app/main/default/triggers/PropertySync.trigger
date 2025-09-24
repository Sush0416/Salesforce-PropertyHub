trigger VisitSMS on Visit__c (after insert) {
    for (Visit__c visit : Trigger.new) {
        if (visit.Status__c == 'Scheduled') {
            SMSService.sendSMS(visit.Phone__c, 
                'Your property visit is scheduled for ' + visit.Visit_Date__c);
        }
    }
}