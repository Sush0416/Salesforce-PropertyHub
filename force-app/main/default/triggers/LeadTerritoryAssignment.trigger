trigger LeadTerritoryAssignment on Lead (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        TerritoryAssignment.assignLeadsByTerritory(Trigger.new);
    }
}