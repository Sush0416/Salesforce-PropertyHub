public class PropertyAPI {
    
    @AuraEnabled
    public static void syncProperties() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:PropertyAPI/properties');
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            List<Property__c> properties = parseProperties(res.getBody());
            upsert properties External_Id__c;
        } else {
            throw new CalloutException('API Error: ' + res.getStatusCode());
        }
    }
    
    @AuraEnabled
    public static void upsertProperties(List<Property__c> properties) {
        upsert properties External_Id__c;
    }
    
    private static List<Property__c> parseProperties(String jsonData) {
        // Parse JSON and map to Property__c object
        return (List<Property__c>) JSON.deserialize(jsonData, List<Property__c>.class);
    }
}