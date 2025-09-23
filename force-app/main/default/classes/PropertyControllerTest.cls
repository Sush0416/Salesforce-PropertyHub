@isTest
private class PropertyControllerTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test properties
        List<Property__c> testProperties = new List<Property__c>();
        for (Integer i = 0; i < 5; i++) {
            testProperties.add(new Property__c(
                Name = 'Test Property ' + i,
                Address__c = '123' + i + ' Test St',
                City__c = 'Test City',
                State__c = 'CA',
                Zip_Code__c = '9000' + i,
                Price__c = 500000 + (i * 100000),
                Bathrooms__c = 2 + (i * 0.5),
                Square_Feet__c = 2000 + (i * 500),
                Property_Type__c = 'Single Family',
                Status__c = 'Available',
                Listing_Date__c = Date.today().addDays(-30)
            ));
        }
        insert testProperties;
        
        // Create test leads
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 3; i++) {
            testLeads.add(new Lead(
                FirstName = 'Test',
                LastName = 'Lead ' + i,
                Email = 'test' + i + '@example.com',
                Phone = '555-000-' + i,
                Company = 'Test Company ' + i
            ));
        }
        insert testLeads;
        
        // Create test property visits
        List<Property_Visit__c> testVisits = new List<Property_Visit__c>();
        for (Integer i = 0; i < 3; i++) {
            testVisits.add(new Property_Visit__c(
                Property__c = testProperties[i].Id,
                Lead__c = testLeads[i].Id,
                Visit_Date__c = Date.today().addDays(7),
                Visit_Time__c = Time.newInstance(10, 0, 0, 0),
                Status__c = 'Scheduled'
            ));
        }
        insert testVisits;
    }
    
    @isTest
    static void testGetProperties() {
        Test.startTest();
        List<Property__c> properties = PropertyController.getProperties(null, null, null, null, null, null, null);
        Test.stopTest();
        
        System.assertEquals(5, properties.size(), 'Should return all test properties');
    }
    
    @isTest
    static void testGetPropertiesWithFilters() {
        Test.startTest();
        List<Property__c> properties = PropertyController.getProperties('Test Property', 600000, null, 4, null, 'Single Family', 'Test City');
        Test.stopTest();
        
        System.assert(properties.size() > 0, 'Should return filtered properties');
    }
    
    @isTest
    static void testGetPropertyDetails() {
        Property__c testProp = [SELECT Id FROM Property__c LIMIT 1];
        
        Test.startTest();
        PropertyController.PropertyWrapper result = PropertyController.getPropertyDetails(testProp.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, result.property, 'Should return property details');
        System.assertEquals(1, result.visits.size(), 'Should return related visits');
    }
    
    @isTest
    static void testUpdatePropertyStatus() {
        Property__c testProp = [SELECT Id, Status__c FROM Property__c LIMIT 1];
        
        Test.startTest();
        PropertyController.updatePropertyStatus(testProp.Id, 'Under Contract');
        Test.stopTest();
        
        Property__c updatedProp = [SELECT Status__c FROM Property__c WHERE Id = :testProp.Id];
        System.assertEquals('Under Contract', updatedProp.Status__c, 'Status should be updated');
    }
}