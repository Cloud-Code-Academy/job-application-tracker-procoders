trigger InterviewContactTrigger on Interview_Contact__c (after insert) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            InterviewContToApplicationConHelper.createApplicationContacts(Trigger.new);
        }
    }
}

//weirdsourcer