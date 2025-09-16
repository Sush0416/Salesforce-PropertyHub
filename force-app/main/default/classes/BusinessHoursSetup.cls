public class BusinessHoursSetup {
    public static void createDefaultBusinessHours() {
        // Check if business hours already exist
        List<BusinessHours> existingHours = [SELECT Id FROM BusinessHours WHERE Name = 'PropertyHub Business Hours'];
        
        if (existingHours.isEmpty()) {
            BusinessHours bh = new BusinessHours(
                Name = 'PropertyHub Business Hours',
                MondayStartTime = Time.newInstance(9, 0, 0, 0),
                MondayEndTime = Time.newInstance(17, 0, 0, 0),
                TuesdayStartTime = Time.newInstance(9, 0, 0, 0),
                TuesdayEndTime = Time.newInstance(17, 0, 0, 0),
                WednesdayStartTime = Time.newInstance(9, 0, 0, 0),
                WednesdayEndTime = Time.newInstance(17, 0, 0, 0),
                ThursdayStartTime = Time.newInstance(9, 0, 0, 0),
                ThursdayEndTime = Time.newInstance(17, 0, 0, 0),
                FridayStartTime = Time.newInstance(9, 0, 0, 0),
                FridayEndTime = Time.newInstance(17, 0, 0, 0),
                SaturdayStartTime = null,
                SaturdayEndTime = null,
                SundayStartTime = null,
                SundayEndTime = null,
                IsActive = true,
                TimeZoneSidKey = 'America/New_York'
            );
            insert bh;
            System.debug('Default business hours created: ' + bh.Id);
        }
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