public with sharing class DataManagementController {

    @AuraEnabled
    public static String importProperties(String csvData) {
        try {
            List<Property__c> propertiesToInsert = new List<Property__c>();
            List<String> csvLines = csvData.split('\n');

            for(Integer i = 1; i < csvLines.size(); i++) { // Skip header
                String[] fields = csvLines[i].split(',');
                if (fields.size() >= 5) {
                    Property__c prop = new Property__c(
                        Name = fields[0].trim(),
                        Address__c = fields[1].trim(),
                        Property_Type__c = fields[2].trim(),
                        Price__c = Decimal.valueOf(fields[3].trim()),
                        Bedrooms__c = Integer.valueOf(fields[4].trim()),
                        Status__c = 'Available'
                    );
                    propertiesToInsert.add(prop);
                }
            }

            Database.SaveResult[] results = Database.insert(propertiesToInsert, false);
            return processImportResults(results);

        } catch(Exception e) {
            throw new AuraHandledException('Import failed: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static String importLeads(String csvData) {
        try {
            List<Lead> leadsToInsert = new List<Lead>();
            List<String> csvLines = csvData.split('\n');

            for(Integer i = 1; i < csvLines.size(); i++) { // Skip header
                String[] fields = csvLines[i].split(',');
                if (fields.size() >= 3) {
                    Lead lead = new Lead(
                        FirstName = fields[0].trim(),
                        LastName = fields[1].trim(),
                        Email = fields[2].trim(),
                        Phone = fields.size() > 3 ? fields[3].trim() : null,
                        Company = fields.size() > 4 ? fields[4].trim() : 'Individual',
                        Status = 'New'
                    );
                    leadsToInsert.add(lead);
                }
            }

            Database.SaveResult[] results = Database.insert(leadsToInsert, false);
            return processImportResults(results);

        } catch(Exception e) {
            throw new AuraHandledException('Import failed: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static String exportProperties(String statusFilter) {
        try {
            String query = 'SELECT Name, Address__c, Property_Type__c, Price__c, Bedrooms__c, Status__c, CreatedDate FROM Property__c';
            if (String.isNotBlank(statusFilter) && statusFilter != 'All') {
                query += ' WHERE Status__c = :statusFilter';
            }

            List<Property__c> properties = Database.query(query);

            String csvHeader = 'Name,Address,Type,Price,Bedrooms,Status,CreatedDate\n';
            String csvBody = '';

            for(Property__c prop : properties) {
                csvBody += '"' + String.escapeSingleQuotes(prop.Name) + '","' +
                          String.escapeSingleQuotes(prop.Address__c) + '","' +
                          String.escapeSingleQuotes(prop.Property_Type__c) + '",' +
                          prop.Price__c + ',' +
                          prop.Bedrooms__c + ',"' +
                          String.escapeSingleQuotes(prop.Status__c) + '","' +
                          prop.CreatedDate + '"\n';
            }

            return csvHeader + csvBody;

        } catch(Exception e) {
            throw new AuraHandledException('Export failed: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static String exportLeads(String statusFilter) {
        try {
            String query = 'SELECT FirstName, LastName, Email, Phone, Company, Status, CreatedDate FROM Lead';
            if (String.isNotBlank(statusFilter) && statusFilter != 'All') {
                query += ' WHERE Status = :statusFilter';
            }

            List<Lead> leads = Database.query(query);

            String csvHeader = 'FirstName,LastName,Email,Phone,Company,Status,CreatedDate\n';
            String csvBody = '';

            for(Lead lead : leads) {
                csvBody += '"' + String.escapeSingleQuotes(lead.FirstName) + '","' +
                          String.escapeSingleQuotes(lead.LastName) + '","' +
                          String.escapeSingleQuotes(lead.Email) + '","' +
                          String.escapeSingleQuotes(lead.Phone) + '","' +
                          String.escapeSingleQuotes(lead.Company) + '","' +
                          String.escapeSingleQuotes(lead.Status) + '","' +
                          lead.CreatedDate + '"\n';
            }

            return csvHeader + csvBody;

        } catch(Exception e) {
            throw new AuraHandledException('Export failed: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> getImportHistory() {
        List<String> history = new List<String>();

        // Query recent data migration logs
        List<Data_Migration_Log__c> logs = [
            SELECT Object_Type__c, Batch_Size__c, Timestamp__c, Error_Message__c
            FROM Data_Migration_Log__c
            ORDER BY Timestamp__c DESC
            LIMIT 10
        ];

        for (Data_Migration_Log__c log : logs) {
            String logEntry = log.Timestamp__c + ' - ' + log.Object_Type__c +
                            ' - Records: ' + log.Batch_Size__c;
            if (String.isNotBlank(log.Error_Message__c)) {
                logEntry += ' - Error: ' + log.Error_Message__c;
            }
            history.add(logEntry);
        }

        return history;
    }

    @AuraEnabled
    public static Map<String, Integer> getDataStatistics() {
        Map<String, Integer> stats = new Map<String, Integer>();

        // Get record counts
        stats.put('totalProperties', [SELECT COUNT() FROM Property__c]);
        stats.put('totalLeads', [SELECT COUNT() FROM Lead]);
        stats.put('duplicateProperties', [SELECT COUNT() FROM Property__c WHERE IsDuplicate__c = true]);
        stats.put('duplicateLeads', [SELECT COUNT() FROM Lead WHERE IsDuplicate__c = true]);

        return stats;
    }

    private static String processImportResults(Database.SaveResult[] results) {
        Integer successCount = 0;
        Integer errorCount = 0;
        String errorMessages = '';

        for(Database.SaveResult sr : results) {
            if(sr.isSuccess()) {
                successCount++;
            } else {
                errorCount++;
                for(Database.Error err : sr.getErrors()) {
                    errorMessages += err.getMessage() + '; ';
                }
            }
        }

        String result = 'Success: ' + successCount + ', Errors: ' + errorCount;
        if (errorCount > 0) {
            result += ' - Errors: ' + errorMessages;
        }

        return result;
    }
}
