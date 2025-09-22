trigger LeadTrigger on Lead (before insert, before update) {
    if (Trigger.isBefore) {
        TerritoryAssignment.assignLeadsByTerritory(Trigger.new);
    }
}