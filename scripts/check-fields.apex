// Check what fields exist on Property__c
Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Property__c.fields.getMap();
for (String fieldName : fieldMap.keySet()) {
    System.debug('Field: ' + fieldName + ' - Type: ' + fieldMap.get(fieldName).getDescribe().getType());
}
