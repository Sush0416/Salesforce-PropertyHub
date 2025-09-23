public with sharing class PropertyController {

    // Get properties with filters (temporary for testing)
    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties(String searchKey, Decimal minPrice, Decimal maxPrice,
                                                Integer minBathrooms, Integer maxBathrooms,
                                                String propertyType, String city) {
        // Temporary query for testing: returns 5 properties regardless of filters
        return [SELECT Id, Name, Price__c, Status__c FROM Property__c LIMIT 5];
    }

    // Get property by ID with related visits and offers
    @AuraEnabled(cacheable=true)
    public static PropertyWrapper getPropertyDetails(String propertyId) {
        PropertyWrapper result = new PropertyWrapper();
        
        result.property = [SELECT Id, Name, Address__c, City__c, State__c, Zip_Code__c,
                          Price__c, Bathrooms__c, Square_Feet__c,
                          Property_Type__c, Status__c, Listing_Date__c
                          FROM Property__c
                          WHERE Id = :propertyId];
        
        result.visits = [SELECT Id, Name, Visit_Date__c, Visit_Time__c, Status__c,
                        Lead__r.Name, Lead__r.Email, Lead__r.Phone
                        FROM Property_Visit__c
                        WHERE Property__c = :propertyId
                        ORDER BY Visit_Date__c DESC, Visit_Time__c DESC
                        LIMIT 10];
        
        result.offers = [SELECT Id, Name, Offer_Amount__c, Offer_Date__c, Status__c,
                        Opportunity__r.Name, Opportunity__r.StageName
                        FROM Offer__c 
                        WHERE Property__c = :propertyId 
                        ORDER BY Offer_Date__c DESC 
                        LIMIT 10];
        
        return result;
    }
    
    // Update property status
    @AuraEnabled
    public static void updatePropertyStatus(String propertyId, String newStatus) {
        Property__c prop = new Property__c(
            Id = propertyId,
            Status__c = newStatus
        );
        update prop;
    }
    
    // Wrapper class for property details
    public class PropertyWrapper {
        @AuraEnabled public Property__c property;
        @AuraEnabled public List<Property_Visit__c> visits;
        @AuraEnabled public List<Offer__c> offers;
    }
}