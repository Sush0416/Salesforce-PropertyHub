@IsTest
public class TerritoryAssignmentTest {

    @IsTest
    static void testAssignLeadsByTerritory() {
        // Step 1: Create test Users with Territory_Postal_Code__c
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];

        User northUser = new User(
            Alias = 'northu',
            Email = 'northuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'North',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'Asia/Kolkata',
            UserName = 'northuser'+Math.random()+'@example.com',
            Territory_Postal_Code__c = '100001'
        );
        insert northUser;

        User southUser = new User(
            Alias = 'southu',
            Email = 'southuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'South',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'Asia/Kolkata',
            UserName = 'southuser'+Math.random()+'@example.com',
            Territory_Postal_Code__c = '200001'
        );
        insert southUser;

        // Step 2: Create Leads with postal codes
        Lead lead1 = new Lead(
            FirstName = 'Test1',
            LastName = 'Lead1',
            Company = 'TestCompany',
            PostalCode = '100001'
        );

        Lead lead2 = new Lead(
            FirstName = 'Test2',
            LastName = 'Lead2',
            Company = 'TestCompany',
            PostalCode = '200001'
        );

        Lead lead3 = new Lead(
            FirstName = 'Test3',
            LastName = 'Lead3',
            Company = 'TestCompany',
            PostalCode = '999999' // No user, should go to queue
        );

        List<Lead> leads = new List<Lead>{lead1, lead2, lead3};

        // Step 3: Create fallback queue if not exist
        Group queueGroup = [SELECT Id FROM Group WHERE Type='Queue' AND Name='Lead Assignment Queue' LIMIT 1];

        // Step 4: Call the method
        Test.startTest();
        TerritoryAssignment.assignLeadsByTerritory(leads);
        Test.stopTest();

        // Step 5: Verify results
        System.assertEquals(northUser.Id, lead1.OwnerId, 'Lead1 should be assigned to North User');
        System.assertEquals(southUser.Id, lead2.OwnerId, 'Lead2 should be assigned to South User');
        System.assertEquals(queueGroup.Id, lead3.OwnerId, 'Lead3 should be assigned to fallback queue');
    }
}