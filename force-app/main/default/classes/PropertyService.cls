public class PropertyService {
    
    public static List<Property__c> getAvailableProperties(String city, Decimal minPrice, Decimal maxPrice, Integer bedrooms) {
        String query = 'SELECT Id, Name, Address__c, City__c, Price__c, Bedrooms__c, Bathrooms__c, ' +
                      'Square_Feet__c, Property_Type__c, Status__c, Listing_Date__c ' +
                      'FROM Property__c ' +
                      'WHERE Status__c = \'Available\'';
        
        List<String> conditions = new List<String>();
        
        if (String.isNotBlank(city)) {
            conditions.add('City__c = :city');
        }
        if (minPrice != null) {
            conditions.add('Price__c >= :minPrice');
        }
        if (maxPrice != null) {
            conditions.add('Price__c <= :maxPrice');
        }
        if (bedrooms != null) {
            conditions.add('Bedrooms__c >= :bedrooms');
        }
        
        if (!conditions.isEmpty()) {
            query += ' AND ' + String.join(conditions, ' AND ');
        }
        
        query += ' ORDER BY Price__c ASC';
        
        return Database.query(query);
    }
    
    public static void updatePropertyStatus(Set<Id> propertyIds, String newStatus) {
        List<Property__c> propertiesToUpdate = new List<Property__c>();
        
        for (Property__c prop : [SELECT Id, Status__c FROM Property__c WHERE Id IN :propertyIds]) {
            prop.Status__c = newStatus;
            propertiesToUpdate.add(prop);
        }
        
        if (!propertiesToUpdate.isEmpty()) {
            update propertiesToUpdate;
        }
    }
    
    public static Map<String, Integer> getPropertyStatsByCity() {
        Map<String, Integer> stats = new Map<String, Integer>();
        
        for (AggregateResult ar : [
            SELECT City__c, COUNT(Id) total
            FROM Property__c 
            WHERE Status__c = 'Available'
            GROUP BY City__c
            ORDER BY COUNT(Id) DESC
        ]) {
            stats.put((String)ar.get('City__c'), (Integer)ar.get('total'));
        }
        
        return stats;
    }
}