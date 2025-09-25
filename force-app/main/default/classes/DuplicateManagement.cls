public with sharing class DuplicateManagement {

    /**
     * Checks for duplicate leads based on email and phone
     * @param newLeads List of new leads to check
     * @return Map of lead index to duplicate lead IDs
     */
    public static Map<Integer, List<Id>> checkDuplicateLeads(List<Lead> newLeads) {
        Map<Integer, List<Id>> duplicateMap = new Map<Integer, List<Id>>();

        // Collect emails and phones to check
        Set<String> emailSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();

        for (Lead lead : newLeads) {
            if (String.isNotBlank(lead.Email)) {
                emailSet.add(lead.Email.toLowerCase().trim());
            }
            if (String.isNotBlank(lead.Phone)) {
                phoneSet.add(lead.Phone.replaceAll('[^0-9]', ''));
            }
        }

        // Query existing leads with matching criteria
        List<Lead> existingLeads = [
            SELECT Id, Email, Phone, IsDuplicate__c
            FROM Lead
            WHERE (Email IN :emailSet OR Phone IN :phoneSet)
            AND IsConverted = false
        ];

        // Create maps for quick lookup
        Map<String, List<Id>> emailToLeadIds = new Map<String, List<Id>>();
        Map<String, List<Id>> phoneToLeadIds = new Map<String, List<Id>>();

        for (Lead existingLead : existingLeads) {
            if (String.isNotBlank(existingLead.Email)) {
                String emailKey = existingLead.Email.toLowerCase().trim();
                if (!emailToLeadIds.containsKey(emailKey)) {
                    emailToLeadIds.put(emailKey, new List<Id>());
                }
                emailToLeadIds.get(emailKey).add(existingLead.Id);
            }

            if (String.isNotBlank(existingLead.Phone)) {
                String phoneKey = existingLead.Phone.replaceAll('[^0-9]', '');
                if (!phoneToLeadIds.containsKey(phoneKey)) {
                    phoneToLeadIds.put(phoneKey, new List<Id>());
                }
                phoneToLeadIds.get(phoneKey).add(existingLead.Id);
            }
        }

        // Check new leads against existing ones
        for (Integer i = 0; i < newLeads.size(); i++) {
            Lead newLead = newLeads[i];
            List<Id> duplicates = new List<Id>();

            // Check email duplicates
            if (String.isNotBlank(newLead.Email)) {
                String emailKey = newLead.Email.toLowerCase().trim();
                if (emailToLeadIds.containsKey(emailKey)) {
                    duplicates.addAll(emailToLeadIds.get(emailKey));
                }
            }

            // Check phone duplicates
            if (String.isNotBlank(newLead.Phone)) {
                String phoneKey = newLead.Phone.replaceAll('[^0-9]', '');
                if (phoneToLeadIds.containsKey(phoneKey)) {
                    duplicates.addAll(phoneToLeadIds.get(phoneKey));
                }
            }

            if (!duplicates.isEmpty()) {
                duplicateMap.put(i, duplicates);
            }
        }

        return duplicateMap;
    }

    /**
     * Checks for duplicate properties based on address
     * @param newProperties List of new properties to check
     * @return Map of property index to duplicate property IDs
     */
    public static Map<Integer, List<Id>> checkDuplicateProperties(List<Property__c> newProperties) {
        Map<Integer, List<Id>> duplicateMap = new Map<Integer, List<Id>>();

        // Collect addresses to check
        Set<String> addressSet = new Set<String>();
        for (Property__c prop : newProperties) {
            if (String.isNotBlank(prop.Address__c)) {
                addressSet.add(prop.Address__c.toUpperCase().trim());
            }
        }

        // Query existing properties with matching addresses
        List<Property__c> existingProperties = [
            SELECT Id, Address__c, IsDuplicate__c
            FROM Property__c
            WHERE Address__c IN :addressSet
        ];

        // Create map for quick lookup
        Map<String, List<Id>> addressToPropertyIds = new Map<String, List<Id>>();
        for (Property__c existingProp : existingProperties) {
            if (String.isNotBlank(existingProp.Address__c)) {
                String addressKey = existingProp.Address__c.toUpperCase().trim();
                if (!addressToPropertyIds.containsKey(addressKey)) {
                    addressToPropertyIds.put(addressKey, new List<Id>());
                }
                addressToPropertyIds.get(addressKey).add(existingProp.Id);
            }
        }

        // Check new properties against existing ones
        for (Integer i = 0; i < newProperties.size(); i++) {
            Property__c newProp = newProperties[i];
            if (String.isNotBlank(newProp.Address__c)) {
                String addressKey = newProp.Address__c.toUpperCase().trim();
                if (addressToPropertyIds.containsKey(addressKey)) {
                    duplicateMap.put(i, addressToPropertyIds.get(addressKey));
                }
            }
        }

        return duplicateMap;
    }

    /**
     * Marks leads as duplicates
     * @param leadIds List of lead IDs to mark as duplicates
     */
    public static void markLeadsAsDuplicates(List<Id> leadIds) {
        if (leadIds.isEmpty()) return;

        List<Lead> leadsToUpdate = new List<Lead>();
        for (Id leadId : leadIds) {
            leadsToUpdate.add(new Lead(
                Id = leadId,
                IsDuplicate__c = true,
                Status = 'Duplicate'
            ));
        }

        try {
            update leadsToUpdate;
        } catch (DmlException e) {
            System.debug('Error marking leads as duplicates: ' + e.getMessage());
        }
    }

    /**
     * Marks properties as duplicates
     * @param propertyIds List of property IDs to mark as duplicates
     */
    public static void markPropertiesAsDuplicates(List<Id> propertyIds) {
        if (propertyIds.isEmpty()) return;

        List<Property__c> propertiesToUpdate = new List<Property__c>();
        for (Id propertyId : propertyIds) {
            propertiesToUpdate.add(new Property__c(
                Id = propertyId,
                IsDuplicate__c = true,
                Status__c = 'Duplicate'
            ));
        }

        try {
            update propertiesToUpdate;
        } catch (DmlException e) {
            System.debug('Error marking properties as duplicates: ' + e.getMessage());
        }
    }

    /**
     * Gets duplicate statistics for reporting
     * @return Map containing duplicate statistics
     */
    public static Map<String, Integer> getDuplicateStatistics() {
        Map<String, Integer> stats = new Map<String, Integer>();

        // Count duplicate leads
        Integer duplicateLeads = [
            SELECT COUNT()
            FROM Lead
            WHERE IsDuplicate__c = true
        ];
        stats.put('duplicateLeads', duplicateLeads);

        // Count duplicate properties
        Integer duplicateProperties = [
            SELECT COUNT()
            FROM Property__c
            WHERE IsDuplicate__c = true
        ];
        stats.put('duplicateProperties', duplicateProperties);

        // Count total leads and properties for context
        Integer totalLeads = [
            SELECT COUNT()
            FROM Lead
        ];
        stats.put('totalLeads', totalLeads);

        Integer totalProperties = [
            SELECT COUNT()
            FROM Property__c
        ];
        stats.put('totalProperties', totalProperties);

        return stats;
    }
}
