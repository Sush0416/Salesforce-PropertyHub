// ----------------------
// PropertyHub Org Setup
// ----------------------

// === 2. Insert Buyer Lead ===
List<Lead> existingLeads = [
    SELECT Id FROM Lead WHERE Email = 'buyer1@propertyhub.com' LIMIT 1
];
if (existingLeads.isEmpty()) {
    Lead buyer = new Lead(
        FirstName = 'Alice',
        LastName  = 'Johnson',
        Company   = 'Individual',
        Email     = 'buyer1@propertyhub.com',
        Status    = 'Open - Not Contacted'
    );
    insert buyer;
    System.debug('✅ Inserted lead: Alice Johnson');
} else {
    System.debug('ℹ️ Lead already exists: ' + existingLeads[0].Id);
}

// === 3. Insert Sample Properties (Custom Object: Property__c) ===
List<Property__c> existingProps = [
    SELECT Id FROM Property__c WHERE Name = 'Greenwood Villa' LIMIT 1
];

if (existingProps.isEmpty()) {
    List<Property__c> properties = new List<Property__c>{
        new Property__c(
            Name = 'Greenwood Villa',
            Address__c = 'Downtown',
            Price__c = 750000
        ),
        new Property__c(
            Name = 'Sunset Apartments',
            Address__c = 'Uptown',
            Price__c = 550000
        )
    };
    insert properties;
    System.debug('✅ Inserted sample properties');
} else {
    System.debug('ℹ️ Sample property already exists: ' + existingProps[0].Id);
}

// === Done ===
System.debug('🎉 PropertyHub org setup completed successfully!');
