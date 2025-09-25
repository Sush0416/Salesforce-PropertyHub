public class VisitBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Status__c, Phone__c, Property__c FROM Property_Visit__c WHERE Status__c = \'Planned\''
        );
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Property_Visit__c> visits = (List<Property_Visit__c>)scope;
        for (Property_Visit__c visit : visits) {
            try {
                SMSService.sendSMS(visit.Phone__c, 'Your visit for ' + visit.Property__c + ' is planned!');
            } catch (Exception e) {
                System.debug('Error sending SMS: ' + e.getMessage());
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        // optional finishing logic
    }
}