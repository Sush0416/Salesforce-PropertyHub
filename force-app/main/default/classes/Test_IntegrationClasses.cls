@isTest
public class Test_IntegrationClasses {
    
    @isTest
    static void testPropertySync() {
        Test.setMock(HttpCalloutMock.class, new MockPropertyAPI());
        Test.startTest();
        PropertyAPI.syncProperties();
        Test.stopTest();
        System.assert([SELECT COUNT() FROM Property__c] > 0);
    }
    
    @isTest
    static void testSMSService() {
        Test.setMock(HttpCalloutMock.class, new MockSMSService());
        Test.startTest();
        SMSService.sendSMS('+1234567890', 'Test message');
        Test.stopTest();
        // Assert based on mock behavior
    }
    
    public class MockPropertyAPI implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('[{"External_Id__c":"P001","Name":"Test Property","Asking_Price__c":100000,"Price__c":100000,"Address__c":"123 Test St","Visit_DateTime__c":"2023-01-01T10:00:00Z"}]');
            return res;
        }
    }
    
    public class MockSMSService implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(201);
            return res;
        }
    }
}