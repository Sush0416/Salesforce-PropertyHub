// force-app/main/default/classes/BatchPropertyCleanup.cls
public class BatchPropertyCleanup implements Database.Batchable<SObject>, Database.Stateful {
    
    private Integer totalRecordsProcessed = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Find properties that have been off market for more than 6 months
        Date sixMonthsAgo = Date.today().addMonths(-6);
        return Database.getQueryLocator([
            SELECT Id, Name, Status__c, LastModifiedDate 
            FROM Property__c 
            WHERE Status__c = 'Off Market' 
            AND LastModifiedDate < :sixMonthsAgo
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Property__c> properties) {
        List<Property__c> propertiesToDelete = new List<Property__c>();
        
        for (Property__c prop : properties) {
            propertiesToDelete.add(prop);
            totalRecordsProcessed++;
        }
        
        if (!propertiesToDelete.isEmpty()) {
            delete propertiesToDelete;
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        // Send completion notification
        try {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{UserInfo.getUserEmail()});
            email.setSubject('Property Cleanup Batch Completed');
            email.setPlainTextBody('The batch property cleanup process has completed successfully. ' +
                                 totalRecordsProcessed + ' records were processed.');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        } catch (Exception e) {
            System.debug('Error sending completion email: ' + e.getMessage());
        }
    }
}