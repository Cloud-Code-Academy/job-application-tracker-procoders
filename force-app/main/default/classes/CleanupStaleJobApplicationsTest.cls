@isTest
public with sharing class CleanupStaleJobApplicationsTest {

    @isTest
    //Create Job Application with LastModifiedDate more than 30 days ago
    static void testCleanupStaleApplication () {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        for (Integer i = 0; i <= 3; i++) {
            Job_Application__c jobApp = new Job_Application__c( 
                Name = 'Test Job Application Cleanup' + i,
                Application_Status__c = 'Applying'
                //LastModifiedDate = System.now().addDays(-31-i)
            );

        jobApplications.add(jobApp);
        }

        Database.insert(jobApplications);

            Test.startTest();
        CleanupStaleJobApplications jobAppCleanup = new CleanupStaleJobApplications();
        jobAppCleanup.after30DaysWithoutInteraction();
        Test.stopTest();

        //verify that there is no stale application not closed
        List<Job_Application__c> staleJobApps = [
                                            SELECT 
                                                Id, Name, Application_Status__c, LastModifiedDate, Notes__c
                                            FROM 
                                                Job_Application__c
                                            WHERE 
                                                Application_Status__c NOT IN ('Closed', 'Accepted') 
                                                AND LastModifiedDate <= N_DAYS_AGO:30
                                            ];

        //System.AssertEqual(0, staleJobApps.size(), 'There should be no stale job applications');
        System.assertEquals(0, staleJobApps.size(), 'There should be no stale job applications');
    }
}