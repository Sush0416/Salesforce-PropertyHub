public class UserSetupUtility {
    public static void createUsers() {
        // Create profile map
        Map<String, Profile> profileMap = new Map<String, Profile>();
        for (Profile p : [SELECT Id, Name FROM Profile]) {
            profileMap.put(p.Name, p);
        }
        
        // Create users based on custom metadata or configuration
        List<User> usersToCreate = new List<User>();
        
        // Sample sales agent user
        if (!userExists('sales.agent@propertyhub.com')) {
            usersToCreate.add(new User(
                FirstName = 'Sales',
                LastName = 'Agent',
                Email = 'sales.agent@propertyhub.com',
                Username = 'sales.agent@propertyhub.com',
                Alias = 'sagent',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ProfileId = profileMap.get('Standard User').Id,
                LanguageLocaleKey = 'en_US',
                IsActive = true
            ));
        }
        
        // Sample property manager user
        if (!userExists('property.manager@propertyhub.com')) {
            usersToCreate.add(new User(
                FirstName = 'Property',
                LastName = 'Manager',
                Email = 'property.manager@propertyhub.com',
                Username = 'property.manager@propertyhub.com',
                Alias = 'pmgr',
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ProfileId = profileMap.get('Standard User').Id,
                LanguageLocaleKey = 'en_US',
                IsActive = true
            ));
        }
        
        if (!usersToCreate.isEmpty()) {
            insert usersToCreate;
            
            // Set passwords for new users
            for (User u : usersToCreate) {
                System.setPassword(u.Id, 'TempPassword123');
            }
            
            System.debug('Created ' + usersToCreate.size() + ' users');
        }
    }
    
    private static Boolean userExists(String username) {
        List<User> existingUsers = [SELECT Id FROM User WHERE Username = :username];
        return !existingUsers.isEmpty();
    }
    
    public static void assignLicenses() {
        // This would typically be done via Permission Set Licenses
        // Implementation depends on your specific licensing requirements
        System.debug('License assignment would be implemented here based on org requirements');
    }
}