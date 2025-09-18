@isTest
public class PropertyApprovalTriggerTest {
    @isTest static void testBeforeUpdateValidation() {
        Property__c prop = new Property__c(Name='Test Property', Approval_Status__c='Draft', Price__c=0);
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
        Property__c prop = new Property__c(Name='Test Property', Approval_Status__c='Draft', Price__c=1000, Address__c='123 Test St', City__c='Test City');
        insert prop;

        Test.startTest();
        prop.Approval_Status__c = 'Submitted';
        update prop;
        Test.stopTest();

        Property__c updatedProp = [SELECT Approval_Status__c FROM Property__c WHERE Id = :prop.Id];
        System.assertEquals('Submitted', updatedProp.Approval_Status__c);
    }

    @isTest static void testAfterUpdateApprovalResult() {
        Property__c prop = new Property__c(Name='Test Property', Approval_Status__c='Submitted', Price__c=1000);
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