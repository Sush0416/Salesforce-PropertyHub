@isTest
private class LeadServiceTest {
    @isTest static void testLeadAutomation() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User(
            Username = 'testuser' + DateTime.now().getTime() + '@test.com',
            Email = 'test@test.com',
            LastName = 'TestUser',
            Alias = 'tusr',
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id,
            Territory_Postal_Code__c = '400001'
        );
        insert u;

        Lead l = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Corp',
            PostalCode = '400001',
            Budget__c = 1500000
        );
        insert l;

        Lead fetched = [SELECT OwnerId, Interest_Score__c, Rating FROM Lead WHERE Id = :l.Id];
        System.assertEquals(u.Id, fetched.OwnerId);
        System.assertEquals(70, Integer.valueOf(fetched.Interest_Score__c));
        System.assertEquals('Hot', fetched.Rating);
    }
}