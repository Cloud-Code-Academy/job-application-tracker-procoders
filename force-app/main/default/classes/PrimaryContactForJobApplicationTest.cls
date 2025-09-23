@isTest
public class PrimaryContactForJobApplicationTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test contacts
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            contacts.add(new Contact(LastName = 'Test' + i));
        }
        Database.insert(contacts);

        // Job Applications WITH Primary Contact
        List<Job_Application__c> jobApplicationsWithPrimaryContact = new List<Job_Application__c>();
        for (Integer i = 0; i < 4; i++) {
            jobApplicationsWithPrimaryContact.add(
                new Job_Application__c(Name = 'Test' + i, Primary_Contact__c = contacts[i].Id)
            );
        }

        // Job Applications WITHOUT Primary Contact
        List<Job_Application__c> jobApplicationsWithoutPrimaryContact = new List<Job_Application__c>();
        for (Integer i = 4; i < 10; i++) {
            jobApplicationsWithoutPrimaryContact.add(
                new Job_Application__c(Name = 'Test' + i)
            );
        }

        // Insert all job applications
        List<Job_Application__c> allJobApplications = new List<Job_Application__c>();
        allJobApplications.addAll(jobApplicationsWithPrimaryContact);
        allJobApplications.addAll(jobApplicationsWithoutPrimaryContact);
        Database.insert(allJobApplications);

        // Create Job Application Contacts
        List<Job_Application_Contact__c> jobApplicationContacts = new List<Job_Application_Contact__c>();
        for (Integer i = 4; i < 7; i++) {
            jobApplicationContacts.add(
                new Job_Application_Contact__c(
                    Job_Application__c = allJobApplications[i].Id,
                    Contact__c = contacts[i].Id
                )
            );
        }
        Database.insert(jobApplicationContacts);
    }

    @isTest
    static void testPrimaryContactAssignmentBatchable() {
        // Get the Job Applications that should be updated
        List<Job_Application__c> jobAppsToCheck = [
            SELECT Id, Name 
            FROM Job_Application__c 
            WHERE Primary_Contact__c = null
            AND Id IN (SELECT Job_Application__c FROM Job_Application_Contact__c)
        ];
        
        Test.startTest();
        PrimaryContactForJobApplicationBatchable batchable = new PrimaryContactForJobApplicationBatchable();
        Database.executeBatch(batchable);
        Test.stopTest();

        // Verify results
        List<Job_Application__c> updatedApps = [
            SELECT Id, Name, Primary_Contact__c 
            FROM Job_Application__c 
            WHERE Id IN :jobAppsToCheck
        ];

        // Assertions
        System.assertEquals(3, updatedApps.size(), 'Expected 3 job applications to be updated');
        for (Job_Application__c app : updatedApps) {
            System.assertNotEquals(null, app.Primary_Contact__c, 
                'Primary contact should not be null for job application: ' + app.Name);
        }
    }

    @isTest
    static void testPrimaryContactAssignmentSchedulable() {
        // Get the Job Applications that should be updated
        List<Job_Application__c> jobAppsToCheck = [
            SELECT Id, Name 
            FROM Job_Application__c 
            WHERE Primary_Contact__c = null
            AND Id IN (SELECT Job_Application__c FROM Job_Application_Contact__c)
        ];
        
        Test.startTest();
        //
        PrimaryContactForJobApplicationSchedule jobPayLoad = new PrimaryContactForJobApplicationSchedule();
        String year = String.valueOf(Date.today().year() + 1);
        String cronExpression = '0 0 2 * * ? ' + year;
        String jobName = 'PrimaryContactForJobApplicationSchedule';
        System.schedule(jobName, cronExpression, jobPayLoad);
        jobPayLoad.execute(null);
        //
        Test.stopTest();

        // Verify results
        List<Job_Application__c> updatedApps = [
            SELECT Id, Name, Primary_Contact__c 
            FROM Job_Application__c 
            WHERE Id IN :jobAppsToCheck
        ];

        // Assertions
        System.assertEquals(3, updatedApps.size(), 'Expected 3 job applications to be updated');
        for (Job_Application__c app : updatedApps) {
            System.assertNotEquals(null, app.Primary_Contact__c, 
                'Primary contact should not be null for job application: ' + app.Name);
        }
    }
}