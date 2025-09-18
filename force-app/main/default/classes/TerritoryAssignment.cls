public class TerritoryAssignment {
    
    public static void assignLeadsByTerritory(List<Lead> newLeads) {
        Map<String, List<Agent_Territory__c>> territoryMap = getTerritoryAgents();

        for(Lead lead : newLeads) {
            if(lead.PostalCode != null) {
                String territory = determineTerritory(lead.PostalCode);
                if(territoryMap.containsKey(territory) && !territoryMap.get(territory).isEmpty()) {
                    Agent_Territory__c assignedAgent = getNextAgent(territoryMap.get(territory));
                    lead.OwnerId = assignedAgent.Id;
                }
            }
        }
    }
    
    private static Map<String, List<Agent_Territory__c>> getTerritoryAgents() {
        Map<String, List<Agent_Territory__c>> territoryMap = new Map<String, List<Agent_Territory__c>>();
        for(Agent_Territory__c at : [SELECT Id, Territory__c FROM Agent_Territory__c WHERE Territory__c != null]) {
            if(!territoryMap.containsKey(at.Territory__c)) {
                territoryMap.put(at.Territory__c, new List<Agent_Territory__c>());
            }
            territoryMap.get(at.Territory__c).add(at);
        }
        return territoryMap;
    }
    
    public static String determineTerritory(String postalCode) {
        if(String.isBlank(postalCode)) return 'North';
        
        // Enhanced territory logic
        if(postalCode.startsWith('1') || postalCode.startsWith('0')) return 'North';
        if(postalCode.startsWith('2') || postalCode.startsWith('3')) return 'South';
        if(postalCode.startsWith('4') || postalCode.startsWith('5')) return 'East';
        if(postalCode.startsWith('6') || postalCode.startsWith('7')) return 'West';
        if(postalCode.startsWith('8') || postalCode.startsWith('9')) return 'Central';
        return 'North';
    }
    
    private static Agent_Territory__c getNextAgent(List<Agent_Territory__c> agents) {
        // Simple round-robin - in production, you might want more sophisticated logic
        Integer index = Math.mod(Integer.valueOf(Math.random() * 1000), agents.size());
        return agents[index];
    }
}