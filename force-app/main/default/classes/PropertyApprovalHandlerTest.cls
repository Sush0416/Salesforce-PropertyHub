// PropertyApprovalHandlerTest.cls
@IsTest
private class PropertyApprovalHandlerTest {
    @TestSetup
    static void setup() {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        insert opp;

        Property__c testProp = new Property__c(
            Name = 'Test Property',
            Address__c = '123 Test St',
            Price__c = 250000,
            Asking_Price__c = 250000,
            Status__c = 'Available',
            Approval_Status__c = 'Draft',
            Visit_DateTime__c = DateTime.now(),
            Opportunity__c = opp.Id
        );
        insert testProp;

        Property_Visit__c visit = new Property_Visit__c(
            Property__c = testProp.Id,
            Visit_Date__c = Date.today(),
            Visit_Time__c = Time.newInstance(10, 0, 0, 0),
            Status__c = 'Scheduled'
        );
        insert visit;
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