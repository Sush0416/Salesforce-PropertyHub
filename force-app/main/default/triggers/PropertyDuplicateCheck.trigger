trigger PropertyDuplicateCheck on Property__c (before insert, before update) {

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        // Check for duplicates only if the property is not already marked as duplicate
        List<Property__c> propertiesToCheck = new List<Property__c>();
        for (Property__c newProperty : Trigger.new) {
            if (!newProperty.IsDuplicate__c) {
                propertiesToCheck.add(newProperty);
            }
        }

        if (!propertiesToCheck.isEmpty()) {
            // Check for duplicates
            Map<Integer, List<Id>> duplicateMap = DuplicateManagement.checkDuplicateProperties(propertiesToCheck);

            // Process duplicates
            for (Integer i = 0; i < propertiesToCheck.size(); i++) {
                Property__c newProperty = propertiesToCheck[i];
                if (duplicateMap.containsKey(i)) {
                    List<Id> duplicateIds = duplicateMap.get(i);

                    // Add error to prevent insert/update
                    String errorMessage = 'Duplicate property found. Similar properties exist with IDs: ';
                    for (Id dupId : duplicateIds) {
                        errorMessage += dupId + ', ';
                    }
                    errorMessage = errorMessage.removeEnd(', ');

                    newProperty.addError(errorMessage);
                }
            }
        }
    }
}
