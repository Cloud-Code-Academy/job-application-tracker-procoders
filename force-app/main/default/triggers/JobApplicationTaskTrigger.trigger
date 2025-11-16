// This trigger was created by Codell for Capstone Project on 9/17/2024

trigger JobApplicationTaskTrigger on Job_Application__c (
        before insert,
        before update,
        after insert,
        after update
) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            
        }
        when BEFORE_UPDATE {

        }
        when AFTER_INSERT {
            // TODO: create tasks for the initial status
            JobApplicationTaskHandler.handleAfterInsert(Trigger.new);
        }
        when AFTER_UPDATE {
            JobApplicationTaskHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
            // TODO: create tasks for the current status if the status change
        }
    }

}