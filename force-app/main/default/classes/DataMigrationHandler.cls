public class DataMigrationHandler implements Database.Batchable<sObject>, Database.Stateful {
    
    private String objectType;
    private Integer totalRecords = 0;
    private Integer processedRecords = 0;
    
    public DataMigrationHandler(String objType) {
        this.objectType = objType;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query;
        if(objectType == 'Lead') {
            query = 'SELECT Id, Name, Email, Phone, Status FROM Lead WHERE Status = \'New\'';
        } else if(objectType == 'Property') {
            query = 'SELECT Id, Name, Address__c, Status__c FROM Property__c WHERE Status__c = \'Available\'';
        }
        
        totalRecords = Database.countQuery('SELECT COUNT() FROM (' + query + ')');
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        try {
            // Perform data transformation/migration logic
            if(objectType == 'Lead') {
                processLeads((List<Lead>)scope);
            } else if(objectType == 'Property') {
                processProperties((List<Property__c>)scope);
            }
            
            processedRecords += scope.size();
            System.debug('Processed ' + processedRecords + ' of ' + totalRecords + ' records');
            
        } catch(Exception e) {
            System.debug('Migration error: ' + e.getMessage());
            // Log errors to custom object for monitoring
            logError(e.getMessage(), scope.size());
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        // Send completion notification
        sendCompletionEmail();
    }
    
    private void processLeads(List<Lead> leads) {
        // Data cleansing and transformation logic
        for(Lead ld : leads) {
            // Standardize phone format
            if(ld.Phone != null) {
                ld.Phone = ld.Phone.replaceAll('[^0-9]', '');
            }
            // Email validation and standardization
            if(ld.Email != null) {
                ld.Email = ld.Email.toLowerCase().trim();
            }
        }
        update leads;
    }
    
    private void processProperties(List<Property__c> properties) {
        // Property data standardization
        for(Property__c prop : properties) {
            // Address standardization
            if(prop.Address__c != null) {
                prop.Address__c = prop.Address__c.toUpperCase().trim();
            }
        }
        update properties;
    }
    
    private void logError(String errorMessage, Integer batchSize) {
        Data_Migration_Log__c log = new Data_Migration_Log__c(
            Error_Message__c = errorMessage,
            Batch_Size__c = batchSize,
            Object_Type__c = this.objectType,
            Timestamp__c = System.now()
        );
        insert log;
    }
    
    private void sendCompletionEmail() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{'admin@propertyhub.com'});
        mail.setSubject('Data Migration Completed - ' + objectType);
        mail.setPlainTextBody('Migration completed. Processed: ' + processedRecords + '/' + totalRecords);
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
    }
}