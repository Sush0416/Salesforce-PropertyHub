const { execSync } = require('child_process');

console.log('��� Deploying PropertyHub Automation...');

try {
    console.log('Deploying Apex classes...');
    execSync('sf project deploy start --metadata ApexClass:PropertyApprovalHandler ApexClass:NotificationService ApexClass:BatchPropertyCleanup --target-org sushmita.katariya.cs22257@agentforce.com', { stdio: 'inherit' });
    
    console.log('Deploying fields and record types...');
    execSync('sf project deploy start --metadata CustomField:Property__c.Approval_Status__c CustomField:Property__c.Last_Approval_Date__c RecordType:Property__c.Residential RecordType:Property__c.Commercial --target-org sushmita.katariya.cs22257@agentforce.com', { stdio: 'inherit' });
    
    console.log('Deploying trigger...');
    execSync('sf project deploy start --metadata ApexTrigger:PropertyApprovalTrigger --target-org sushmita.katariya.cs22257@agentforce.com', { stdio: 'inherit' });
    
    console.log('✅ Automation deployment completed successfully!');
    
    console.log('Testing deployment...');
    execSync('sf apex run --class PropertyApprovalHandler --target-org sushmita.katariya.cs22257@agentforce.com', { stdio: 'inherit' });
    
} catch (error) {
    console.error('❌ Automation deployment failed:', error.message);
}
