// Create test property
Property__c testProp = new Property__c(
    Name = 'Test Property',
    Address__c = '123 Test St',
    Price__c = 500000,
    Status__c = 'Draft',
    Approval_Status__c = 'Draft'
);
insert testProp;

System.debug('Test property created: ' + testProp.Id);
