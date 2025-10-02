public with sharing class CleanupStaleJobApplications {

    List<Job_Application__c> jobAppsToInsert = new List<Job_Application__c>();

    //pull all stale applications, close them, and update the note to reflect the change
    public void after30DaysWithoutInteraction() {
        for (Job_Application__c jobApp : [
                                            SELECT 
                                                Id, Name, Application_Status__c, LastModifiedDate, Notes__c

                                            FROM 
                                                Job_Application__c
                                            WHERE 
                                                Application_Status__c NOT IN ('Closed', 'Accepted') 
                                                AND LastModifiedDate <= N_DAYS_AGO:30
                                            ]
                                            ) {

            jobApp.Application_Status__c = 'Closed';
            jobApp.Notes__c = 'This Application was closed by CleanupStaleJobApplications.cls on' + System.now();
            jobAppsToInsert.add(jobApp);                                           
        }

        if(!jobAppsToInsert.isEmpty()) {
            Database.update(jobAppsToInsert);
        }
    
    }
}