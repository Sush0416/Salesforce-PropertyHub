public class LeadService {
    
    // Method to process new Leads
    public static void assignLead(List<Lead> newLeads) {
        // Query a Queue (you can replace Name with your Queue’s name in Setup)
        Group leadQueue = [
            SELECT Id 
            FROM Group 
            WHERE Type = 'Queue' 
              AND Name = 'Lead Assignment Queue' 
            LIMIT 1
        ];
        
        for (Lead l : newLeads) {
            // Example condition: PostalCode = 400001 and Budget >= 1,500,000
            if (l.PostalCode == '400001' && l.Budget__c >= 1500000) {
                l.OwnerId = leadQueue.Id;   // Assign to Queue
                l.Score__c = 70;            // Custom field Score
                l.Rating = 'Hot';           // Standard field Rating
            }
        }
    }
}