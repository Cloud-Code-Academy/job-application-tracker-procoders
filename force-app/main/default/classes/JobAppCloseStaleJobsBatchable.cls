public with sharing class JobAppCloseStaleJobsBatchable implements Database.Batchable<SObject> {

    // TODO: for unit testing, calculate a date 31 days ago from today
    //  and put into a JSON string that is a Job Application 
    //  then deserialize into a Job Application SObject
    //  insert the record

    public JobAppCloseStaleJobsBatchable() {}

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT 
                    Id,
                    Name,
                    Application_Status__c,
                    LastModifiedDate,
                    Notes__c
            FROM Job_Application__c
            WHERE Application_Status__c NOT IN ('Closed', 'Accepted') 
                AND LastModifiedDate <= N_DAYS_AGO:30
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Job_Application__c> scope) {
        for(Job_Application__c jobApp : scope) {
            jobApp.Application_Status__c = 'Closed';
            jobApp.Notes__c = 'This Application was closed by JobAppCloseStaleJobsBatchable.cls on ' + System.now().format();
        }
        List<Database.SaveResult> saveResults = Database.update(scope, false);
    }

    // TODO: maybe notify the user about the job when it's done
    public void finish(Database.BatchableContext bc) {}

}