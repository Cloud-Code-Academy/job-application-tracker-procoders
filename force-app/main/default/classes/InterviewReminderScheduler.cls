// TODO: use Schedulable-Batchable pattern
public with sharing class InterviewReminderScheduler implements Schedulable {
    //Makes viriable visible to test class
    @TestVisible 
    private static Integer lastEmailCount = 0; 

    // TODO: create separate batchable or queueable class to handle logic
    public void execute(SchedulableContext sc) {

        // TODO: fix possible query rows limit exception
        List<Event> upcomingEvents = [
            SELECT Id, Subject, StartDateTime, WhatId, OwnerId, Location, Description, Owner.Email, Owner.Name
            FROM Event
            WHERE DAY_ONLY(StartDateTime) = :Date.today().addDays(1) 
            AND WhatId != null
        ];

        //Hold all email that will be sent
        // TODO: be careful about Messaging.SingleEmailMessage limits, look up how many we can send
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 

        for (Event ev : upcomingEvents) {

            // TODO: evaluate this dynamically (I think this is asking "Who does the event relate to?")
            // OR
            // TODO: only query events that have to do with Job Application Interviews
            // NOTE: you can get the prefix or SObjectType based on an Id
            // EXAMPLE: it's something like this:
            // Job_Application__c.SObjectType.getDescribe().getPrefix();
            // OR 
            // ev.WhatId.getSObjectType() == Job_Application__c.SObjectType
            if (String.valueOf(ev.WhatId).startsWith('a00')) { 

                // Create email
                // TODO: create a method that will build these email messages for you
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 

                // Recipient
                mail.setToAddresses(new String[] {ev.Owner.Email}); 

                // Subject
                mail.setSubject('Interview Reminder: ' + ev.Subject);

                // Format date
                String interviewDate = ev.StartDateTime.format('MMMM dd, yyyy \'at\' h:mm a');

                // Format Email Body 
                mail.setPlainTextBody(
                    'Hello ' + ev.Owner.Name + ',\n\n' +
                    'This is a reminder that you have an interview scheduled on ' +
                    'Subject ' + interviewDate + '\n' +
                    'Location: ' + (ev.Location !=null ? ev.Location : 'Not specified') + '\n' +
                    'Description / Notes: ' + (ev.Description != null ? ev.Description : 'Not provided') +
                    '.\n\n Good Luck! You got this!'); 

                emails.add(mail); 
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        
            lastEmailCount = emails.size(); 
        }
    }
}
//CLJ


