/**
 * This class implements the Database.Batchable interface to process Job Application records
 * and assign a Primary Contact to those that currently do not have one.
 * 
 * The batch job performs the following steps:
 * 1. Queries all Job Application records where the Primary Contact is null.
 * 2. For each Job Application, assigns the first available Contact from the related Job Application Contacts.
 * 3. Updates the Job Application records in the database.
 */
public with sharing class PrimaryContactForJobApplicationBatchable implements Database.Batchable<sObject>{
    //Query for all Bob Applications without primary contact and return the query locator
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT 
                                            Id, Primary_Contact__c,
                                                (SELECT Id, Contact__c
                                                FROM Job_Application_Contacts__r
                                                WHERE Contact__c != null
                                                LIMIT 1)
                                        FROM 
                                            Job_Application__c 
                                        WHERE 
                                            Primary_Contact__c = null
                                            AND Application_Contact_Count__c > 0]);
    }

    /**
     * Executes the batch process for a given scope of Job_Application__c records.
     *
     * This method iterates through the provided scope of Job_Application__c records and sets the 
     * Primary_Contact__c field for each record. If the Job_Application_Contacts__r relationship 
     * is not empty, the Primary_Contact__c field is set to the Contact__c value of the first 
     * related Job_Application_Contact__c record.
     */
    public void execute(Database.BatchableContext bc, List<Job_Application__c> scope){
        for(Job_Application__c jobApp : scope) {
            //jobApp.Primary_Contact__c = jobApp.Job_Application_Contact__rs.isEmpty() ? null : jobApp.Job_Application_Contacts__r[0].Contact__c;
            if (!jobApp.Job_Application_Contacts__r.isEmpty()){
                jobApp.Primary_Contact__c = jobApp.Job_Application_Contacts__r[0].Contact__c;
                //System.debug('jobApp.Primary_Contact__c: ' + jobApp.Primary_Contact__c);
            }
        }

        Database.update(scope, false);    
    }

    public void finish(Database.BatchableContext bc){

    }
}

//weirdsourcer