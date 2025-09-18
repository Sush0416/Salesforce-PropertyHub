public class LeadAssignmentService {
    @InvocableMethod(label='Assign Leads' description='Assigns leads to agents based on territory')
    public static void assignLeads(List<Lead> newLeads) {
        TerritoryAssignment.assignLeadsByTerritory(newLeads);
    }
}