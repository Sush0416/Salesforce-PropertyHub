public with sharing class PropertyController {
    
    // Get properties with filters
    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties(String searchKey, Decimal minPrice, Decimal maxPrice, 
                                                Integer minBedrooms, Integer maxBedrooms, 
                                                String propertyType, String city) {
        String query = 'SELECT Id, Name, Address__c, City__c, State__c, Zip_Code__c, ' +
                      'Price__c, Bedrooms__c, Bathrooms__c, Square_Feet__c, ' +
                      'Property_Type__c, Status__c, Listing_Date__c ' +
                      'FROM Property__c WHERE Status__c = \'Available\'';
        
        List<String> conditions = new List<String>();
        
        if (String.isNotBlank(searchKey)) {
            conditions.add('(Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + 
                          '%\' OR Address__c LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\')');
        }
        
        if (minPrice != null) {
            conditions.add('Price__c >= ' + minPrice);
        }
        
        if (maxPrice != null) {
            conditions.add('Price__c <= ' + maxPrice);
        }
        
        if (minBedrooms != null) {
            conditions.add('Bedrooms__c >= ' + minBedrooms);
        }
        
        if (maxBedrooms != null) {
            conditions.add('Bedrooms__c <= ' + maxBedrooms);
        }
        
        if (String.isNotBlank(propertyType)) {
            conditions.add('Property_Type__c = \'' + String.escapeSingleQuotes(propertyType) + '\'');
        }
        
        if (String.isNotBlank(city)) {
            conditions.add('City__c = \'' + String.escapeSingleQuotes(city) + '\'');
        }
        
        if (!conditions.isEmpty()) {
            query += ' AND ' + String.join(conditions, ' AND ');
        }
        
        query += ' ORDER BY CreatedDate DESC LIMIT 100';
        
        return Database.query(query);
    }
    
    // Get property by ID with related visits and offers
    @AuraEnabled(cacheable=true)
    public static PropertyWrapper getPropertyDetails(String propertyId) {
        PropertyWrapper result = new PropertyWrapper();
        
        result.property = [SELECT Id, Name, Address__c, City__c, State__c, Zip_Code__c,
                          Price__c, Bedrooms__c, Bathrooms__c, Square_Feet__c,
                          Property_Type__c, Status__c, Listing_Date__c
                          FROM Property__c 
                          WHERE Id = :propertyId];
        
        result.visits = [SELECT Id, Name, Visit_DateTime__c, Status__c, 
                        Lead__r.Name, Lead__r.Email, Lead__r.Phone
                        FROM Property_Visit__c 
                        WHERE Property__c = :propertyId 
                        ORDER BY Visit_DateTime__c DESC 
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