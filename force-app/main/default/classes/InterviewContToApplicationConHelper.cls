public with sharing class InterviewContToApplicationConHelper {

    //member variables to store list of Interview_Contact__c
    private List<Interview_Contact__c> interviewContactListToProcess;
    //private Set<Id> jobApplicationIds;
    //private String operationType;


    //constructor to process SObject records from Tigger to interviewContacts List
    public InterviewContToApplicationConHelper(List<SObject> interviewContacts) {
        this.interviewContactListToProcess = (List<Interview_Contact__c>) interviewContacts;
        
        //Pull application Ids for Interview Contacts
        //Set<Id> interviewApplicationIds = new Set<Id>();
        //for (Interview_Contact__c interviewContact : interviewContactListToProcess) {
        //    interviewApplicationIds.add(interviewContact.Job_Application__c);
        //}
        //this.jobApplicationIds = interviewApplicationIds;

        //this.operationType = operationTypeFromTrigger;
    }

    
    //List<Job_Application__c> jobApplications = [SELECT Id FROM Job_Application__c WHERE Id IN :jobApplicationIds];
    public static void createApplicationContacts(List<Interview_Contact__c> interviewContactListToProcess) {
        Set<Id> jobApplicationIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        Set<Job_Application_Contact__c> appContactToInsertCandidate = new Set<Job_Application_Contact__c>();
        for (Interview_Contact__c interviewContact : interviewContactListToProcess) {
            jobApplicationIds.add(interviewContact.Job_Application__c);
            contactIds.add(interviewContact.Contact__c);
            appContactToInsertCandidate.add(new Job_Application_Contact__c(Job_Application__c = interviewContact.Job_Application__c,
                                                                         Contact__c = interviewContact.Contact__c)
                                        );
        }

        //Pull Application Contact for all applications in the interviewContactListToProcess
        Map<String, Job_Application_Contact__c> conpositeKeyToxistingJobApplicationContactsMap = new Map<String, Job_Application_Contact__c>();
        List<Job_Application_Contact__c> existingJobApplicationContactsList = [SELECT Id, Contact__c, Job_Application__c 
                                                                                FROM Job_Application_Contact__c 
                                                                                WHERE Job_Application__c IN :jobApplicationIds
                                                                                AND Contact__c IN :contactIds];
        
        
        for(Job_Application_Contact__c appContact :  existingJobApplicationContactsList) {
                String compositeKey = appContact.Job_Application__c + '-' + appContact.Contact__c;
                conpositeKeyToxistingJobApplicationContactsMap.put(compositeKey, appContact);
        }
        
        // Check for new combinations and add to insert list
        List<Job_Application_Contact__c> applicationContactToInsert = new List<Job_Application_Contact__c>();
        for(Job_Application_Contact__c candidate : appContactToInsertCandidate) {
            String compositeKey = candidate.Job_Application__c + '-' + candidate.Contact__c;
            if(!conpositeKeyToxistingJobApplicationContactsMap.containsKey(compositeKey)) {
                applicationContactToInsert.add(candidate);
            }
        }

        if(!applicationContactToInsert.isEmpty()) {
            Database.insert(applicationContactToInsert);
        }
    }
}