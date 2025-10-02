public with sharing class InterviewReminderScheduler implements Schedulable {

    @TestVisible private static Integer lastEmailCount = 0; 

    public void execute(SchedulableContext sc) {

        List<Event> upcomingEvents = [
            SELECT Id, Subject, StartDateTime, WhatId, OwnerId, Location, Description, Owner.Email, Owner.Name
            FROM Event
            WHERE DAY_ONLY(StartDateTime) = :Date.today().addDays(1) 
            AND WhatId != null
        ];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 

        for (Event ev : upcomingEvents) {

            if (String.valueOf(ev.WhatId).startsWith('a00')) { 

                // Create email
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 

                // Recipient
                mail.setToAddresses(new String[] {ev.Owner.Email}); 

                // Subject
                mail.setSubject('Interview Reminder: ' + ev.Subject);

                // Format date
                String interviewDate = ev.StartDateTime.format('MMMM dd, yyyy \'at\' h:mm a');

                // Body 
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



