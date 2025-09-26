public class Phase9Verification {
    public static void verifyPhase9Setup() {
        System.debug('=== Phase 9 Verification Started ===');
        
        // Check Reports
        List<Report> reports = [SELECT Id, Name FROM Report WHERE Name IN ('LEAD_FUNNEL_REPORT', 'PROPERTY_VISITS_REPORT')];
        System.debug('Found ' + reports.size() + ' reports');
        
        // Check Dashboards
        List<Dashboard> dashboards = [SELECT Id, Title FROM Dashboard WHERE Title = 'Sales Performance Dashboard'];
        System.debug('Dashboard exists: ' + !dashboards.isEmpty());
        
        // Check Permission Sets
        List<PermissionSet> permissionSets = [SELECT Id, Label FROM PermissionSet WHERE Label = 'Sales Agent Permissions'];
        System.debug('Permission Sets found: ' + permissionSets.size());
        
        System.debug('=== Phase 9 Verification Completed ===');
    }
}
