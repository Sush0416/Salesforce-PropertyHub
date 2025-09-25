trigger PropertySync on Property_Visit__c (after insert) {
    for (Property_Visit__c visit : Trigger.new) {
        if (visit.Status__c == 'Scheduled') {
            SMSService.sendSMS(visit.Phone__c,
                'Your property visit is scheduled for ' + visit.Visit_Date__c);
        }
    }
}
