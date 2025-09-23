public class BusinessHoursSetup {
    public static void createDefaultBusinessHours() {
        // Note: BusinessHours cannot be inserted directly via DML
        // This method is for documentation purposes only
        // In a real implementation, you would need to use the BusinessHours UI
        // or contact Salesforce support to create default business hours

        System.debug('BusinessHoursSetup: Direct BusinessHours creation is not supported via Apex DML.');
        System.debug('Please create business hours manually through the Salesforce UI or contact support.');
    }
    
    public static void createHolidays() {
        // Create sample holidays for the current year
        List<Holiday> holidays = new List<Holiday>{
            new Holiday(
                Name = 'New Year\'s Day',
                ActivityDate = Date.newInstance(Date.today().year(), 1, 1),
                RecurrenceType = 'RecursYearly',
                RecurrenceMonthOfYear = 'January',
                RecurrenceDayOfMonth = 1,
                IsAllDay = true
            ),
            new Holiday(
                Name = 'Independence Day',
                ActivityDate = Date.newInstance(Date.today().year(), 7, 4),
                RecurrenceType = 'RecursYearly',
                RecurrenceMonthOfYear = 'July',
                RecurrenceDayOfMonth = 4,
                IsAllDay = true
            )
            // Add more holidays as needed
        };
        
        // Check if holidays already exist
        Set<String> holidayNames = new Set<String>();
        for (Holiday h : holidays) {
            holidayNames.add(h.Name);
        }
        
        List<Holiday> existingHolidays = [SELECT Id, Name FROM Holiday WHERE Name IN :holidayNames];
        Set<String> existingHolidayNames = new Set<String>();
        for (Holiday h : existingHolidays) {
            existingHolidayNames.add(h.Name);
        }
        
        List<Holiday> holidaysToInsert = new List<Holiday>();
        for (Holiday h : holidays) {
            if (!existingHolidayNames.contains(h.Name)) {
                holidaysToInsert.add(h);
            }
        }
        
        if (!holidaysToInsert.isEmpty()) {
            insert holidaysToInsert;
            System.debug('Created ' + holidaysToInsert.size() + ' holidays');
        }
    }
}