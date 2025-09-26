@isTest
public class PropertyApprovalTriggerTest {
    @isTest static void testBeforeUpdateValidation() {
        Opportunity opp = new Opportunity(Name='Test Opp 1', StageName='Prospecting', CloseDate=Date.today().addDays(30));
        insert opp;
        Property__c prop = new Property__c(Name='Test Property 1', Approval_Status__c='Draft', Price__c=0, Asking_Price__c=0, Address__c='123 Test St', Visit_DateTime__c=DateTime.now(), Opportunity__c=opp.Id);
        insert prop;

        Test.startTest();
        try {
            prop.Approval_Status__c = 'Submitted';
            update prop;
            System.assert(false, 'Should have thrown validation error');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Price must be greater than 0'));
        }
        Test.stopTest();
    }

    @isTest static void testAfterUpdateApprovalSubmission() {
        Opportunity opp = new Opportunity(Name='Test Opp 2', StageName='Prospecting', CloseDate=Date.today().addDays(30));
        insert opp;
        Property__c prop = new Property__c(Name='Test Property 2', Approval_Status__c='Draft', Price__c=1000, Asking_Price__c=1000, Address__c='123 Test St', City__c='Test City', Visit_DateTime__c=DateTime.now(), Opportunity__c=opp.Id);
        insert prop;

        Test.startTest();
        prop.Approval_Status__c = 'Submitted';
        update prop;
        Test.stopTest();

        Property__c updatedProp = [SELECT Approval_Status__c FROM Property__c WHERE Id = :prop.Id];
        System.assertEquals('Submitted', updatedProp.Approval_Status__c);
    }

    @isTest static void testAfterUpdateApprovalResult() {
        Opportunity opp = new Opportunity(Name='Test Opp 3', StageName='Prospecting', CloseDate=Date.today().addDays(30));
        insert opp;
        Property__c prop = new Property__c(Name='Test Property 3', Approval_Status__c='Submitted', Price__c=1000, Asking_Price__c=1000, Address__c='123 Test St', Visit_DateTime__c=DateTime.now(), Opportunity__c=opp.Id);
        insert prop;

        Test.startTest();
        prop.Approval_Status__c = 'Approved';
        update prop;
        Test.stopTest();

        Property__c updatedProp = [SELECT Approval_Status__c, Status__c FROM Property__c WHERE Id = :prop.Id];
        System.assertEquals('Approved', updatedProp.Approval_Status__c);
        System.assertEquals('Available', updatedProp.Status__c);
    }
}