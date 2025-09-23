public with sharing class InterviewContToApplicationConHelper {

    //member variables to store list of Interview_Contact__c
    private List<Interview_Contact__c> interviewContactListToProcess;
    private String operationType;


    //constructor to process SObject records from Tigger to interviewContacts List
    public InterviewContToApplicationConHelper(List<SObject> interviewContacts, String operationTypeFromTrigger) {
        this.interviewContactListToProcess = (List<Interview_Contact__c>) interviewContacts;
        this.operationType = operationTypeFromTrigger;
    }

    public static void createApplicationContacts(List<Interview_Contact__c> interviewContactListToProcess) {
        Set<Id> jobApplicationIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        for (Interview_Contact__c interviewContact : interviewContactListToProcess) {
            //jobApplicationIds.add(interviewContact.Job_Application__c);
            contactIds.add(interviewContact.Contact__c);
        }
        //Check if there Application has a matching Application Contact
        List<Job_Application_Contact__c> jobApplicationContacts = [SELECT 
                                                                        Id, Contact__c, Job_Application__c 
                                                                    FROM 
                                                                        Job_Application_Contact__c 
                                                                    WHERE 
                                                                        //Job_Application__c IN :jobApplicationIds
                                                                        Contact__c IN :contactIds];

    }
}