// PropertyApprovalHandlerTest.cls
@IsTest
private class PropertyApprovalHandlerTest {
    @TestSetup
    static void setup() {
        Property__c testProp = new Property__c(
            Name = 'Test Property',
            Address__c = '123 Test St',
            Price__c = 250000,
            Status__c = 'Available',
            Approval_Status__c = 'Draft'
        );
        insert testProp;
    }
    
    @IsTest
    static void testSubmitForApproval() {
        Property__c prop = [SELECT Id FROM Property__c LIMIT 1];
        prop.Approval_Status__c = 'Submitted';
        Test.startTest();
        update prop;
        Test.stopTest();
        Property__c updatedProp = [SELECT Approval_Status__c FROM Property__c WHERE Id = :prop.Id];
        System.assertEquals('Submitted', updatedProp.Approval_Status__c);
    }
}