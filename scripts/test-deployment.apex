// Simple test to check if classes are available
try {
    // Test if PropertyApprovalHandler exists
    Type handlerType = Type.forName('PropertyApprovalHandler');
    if (handlerType != null) {
        System.debug('PropertyApprovalHandler class is available');
    } else {
        System.debug('PropertyApprovalHandler class NOT found');
    }
    
    // Test if NotificationService exists
    Type serviceType = Type.forName('NotificationService');
    if (serviceType != null) {
        System.debug('NotificationService class is available');
    } else {
        System.debug('NotificationService class NOT found');
    }
    
    System.debug('Deployment test completed');
} catch (Exception e) {
    System.debug('Error in test: ' + e.getMessage());
}
