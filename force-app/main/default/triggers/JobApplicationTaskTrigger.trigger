// This trigger was created by Codell for Capstone Project on 9/17/2024

trigger JobApplicationTaskTrigger on Job_Application__c (after insert, after update) {

    JobApplicationTaskHandler.run(
        Trigger.new,
        Trigger.oldMap,
        Trigger.isInsert,
        Trigger.isUpdate
);

}