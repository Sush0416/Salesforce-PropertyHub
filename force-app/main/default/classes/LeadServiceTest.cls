@isTest
private class LeadServiceTest {

    @testSetup
    static void setupTestData() {
        // Create a test user with a territory
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testAgent = new User(
            Alias = 'tagent',
            Email = 'test.agent@propertyhub.test',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestAgent',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = salesProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'test.agent@propertyhub.test',
            Territory_Postal_Code__c = '400001'
        );
        insert testAgent;
    }

    @isTest
    static void testLeadAssignmentAndScoring() {
        User testAgent = [SELECT Id, Territory_Postal_Code__c FROM User WHERE UserName = 'test.agent@propertyhub.test'];

        Test.startTest();
        // Create a new lead that matches the agent's territory
        Lead testLead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Test Company',
            PostalCode = '400001', // Matches the agent's territory
            Budget__c = 1500000, // High budget -> high score
            Description = 'Looking for an immediate purchase of a 3BHK apartment.',
            Status = 'Open - Not Contacted'
        );
        insert testLead;
        Test.stopTest();

        // Re-query the lead to get updated fields
        Lead updatedLead = [SELECT Id, OwnerId, Interest_Score__c, Rating FROM Lead WHERE Id = :testLead.Id];

        // Assert that the lead was assigned to the test agent
        System.assertEquals(testAgent.Id, updatedLead.OwnerId, 'Lead was not assigned to the correct territorial agent.');

        // Assert that the interest score was calculated (30 + 25 + 15 = 70)
        System.assertEquals(70, updatedLead.Interest_Score__c, 'Interest score was not calculated correctly.');

        // Assert that the lead was rated 'Hot'
        System.assertEquals('Hot', updatedLead.Rating, 'Lead was not auto-qualified to Hot.');
    }
}