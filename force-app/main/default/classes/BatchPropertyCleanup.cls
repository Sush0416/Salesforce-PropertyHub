public class BatchPropertyCleanup implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date sixMonthsAgo = Date.today().addMonths(-6);
        return Database.getQueryLocator([
            SELECT Id, Name, Status__c, LastModifiedDate 
            FROM Property__c 
            WHERE Status__c = 'Off Market' 
            AND LastModifiedDate < :sixMonthsAgo
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Property__c> properties) {
        delete properties;
    }
    
    public void finish(Database.BatchableContext bc) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{UserInfo.getUserEmail()});
        email.setSubject('Property Cleanup Batch Completed');
        email.setPlainTextBody('The batch property cleanup process has completed successfully.');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
    }
}