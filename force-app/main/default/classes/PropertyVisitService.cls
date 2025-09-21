public with sharing class PropertyVisitService {
    public static void checkForSchedulingConflicts(List<Property_Visit__c> newVisits) {
        if (newVisits == null || newVisits.isEmpty()) return;
        
        Set<Id> propertyIds = new Set<Id>();
        Set<Id> agentIds = new Set<Id>();
        
        for (Property_Visit__c visit : newVisits) {
            if (visit.Property__c != null) propertyIds.add(visit.Property__c);
            if (visit.Agent__c != null) agentIds.add(visit.Agent__c);
        }
        
        if (propertyIds.isEmpty() && agentIds.isEmpty()) return;
        
        List<Property_Visit__c> existingVisits = [
            SELECT Id, Property__c, Agent__c, Visit_DateTime__c
            FROM Property_Visit__c
            WHERE (Property__c IN :propertyIds OR Agent__c IN :agentIds)
            AND Id NOT IN :newVisits
        ];
        
        for (Property_Visit__c newVisit : newVisits) {
            for (Property_Visit__c existingVisit : existingVisits) {
                Boolean isSameProperty = newVisit.Property__c == existingVisit.Property__c;
                Boolean isSameAgent = newVisit.Agent__c == existingVisit.Agent__c;
                
                if (newVisit.Visit_DateTime__c != null && existingVisit.Visit_DateTime__c != null) {
                    Long timeDifference = Math.abs(newVisit.Visit_DateTime__c.getTime() - existingVisit.Visit_DateTime__c.getTime());
                    Long oneHourInMs = 60 * 60 * 1000;
                    Boolean isWithinHourBuffer = timeDifference < oneHourInMs;
                    
                    if ((isSameProperty || isSameAgent) && isWithinHourBuffer) {
                        newVisit.addError('Scheduling Conflict: This property or agent is already booked for a visit at this time.');
                        break;
                    }
                }
            }
        }
    }
}