// Simple test data creation - using fields that exist
Property__c testProp = new Property__c(
    Name = 'Test Property 123',
    Address__c = '123 Main Street',
    Price__c = 350000,
    Status__c = 'Draft',
    Approval_Status__c = 'Draft'
);
insert testProp;

System.debug('Test property created with ID: ' + testProp.Id);
System.debug('Test property name: ' + testProp.Name);
System.debug('Test property status: ' + testProp.Status__c);
