public class OrgSetupController {
    @InvocableMethod(label='Initialize PropertyHub Org' description='Runs all setup procedures for a new PropertyHub org')
    public static void initializeOrg() {
        // Execute all setup procedures in order
        BusinessHoursSetup.createDefaultBusinessHours();
        BusinessHoursSetup.createHolidays();
        UserSetupUtility.createUsers();
        UserSetupUtility.assignLicenses();
        
        // Configure fiscal year if needed
        setupFiscalYear();
        
        System.debug('PropertyHub org initialization completed successfully');
    }
    
    private static void setupFiscalYear() {
        // This would typically configure the fiscal year settings
        // Note: Fiscal year settings can't be modified via Apex in most cases
        // This would usually be done through setup UI or metadata API
        System.debug('Fiscal year setup would be implemented based on organization requirements');
    }
    
    // Method to verify org setup completion
    public static Boolean verifySetup() {
        Boolean isSetupComplete = true;
        
        // Check business hours
        List<BusinessHours> bh = [SELECT Id FROM BusinessHours WHERE Name = 'PropertyHub Business Hours'];
        if (bh.isEmpty()) {
            System.debug('Business hours not configured');
            isSetupComplete = false;
        }
        
        // Check users
        Integer userCount = [SELECT COUNT() FROM User WHERE IsActive = true];
        if (userCount < 2) { // At least admin + one user
            System.debug('Insufficient users configured');
            isSetupComplete = false;
        }
        
        return isSetupComplete;
    }
}