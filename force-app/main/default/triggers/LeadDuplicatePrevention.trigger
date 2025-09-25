trigger LeadDuplicatePrevention on Lead (before insert, before update) {

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        // Check for duplicates only if the lead is not already marked as duplicate
        List<Lead> leadsToCheck = new List<Lead>();
        for (Lead newLead : Trigger.new) {
            if (!newLead.IsDuplicate__c) {
                leadsToCheck.add(newLead);
            }
        }

        if (!leadsToCheck.isEmpty()) {
            // Check for duplicates
            Map<Integer, List<Id>> duplicateMap = DuplicateManagement.checkDuplicateLeads(leadsToCheck);

            // Process duplicates
            for (Integer i = 0; i < leadsToCheck.size(); i++) {
                Lead newLead = leadsToCheck[i];
                if (duplicateMap.containsKey(i)) {
                    List<Id> duplicateIds = duplicateMap.get(i);

                    // Add error to prevent insert/update
                    String errorMessage = 'Duplicate lead found. Similar leads exist with IDs: ';
                    for (Id dupId : duplicateIds) {
                        errorMessage += dupId + ', ';
                    }
                    errorMessage = errorMessage.removeEnd(', ');

                    newLead.addError(errorMessage);
                }
            }
        }
    }
}
