public with sharing class JobApplicationTaskHandler {

    public static void run(
        List<Job_Application__c> newList,
        Map<Id, Job_Application__c> oldMap,
        Boolean isInsert,
        Boolean isUpdate) {
        
        //List that holds task
        List<Task> tasksToInsert = new List<Task>(); 

        for (Job_Application__c newApp : newList) {

        //Check for status change
        if (isUpdate && oldMap != null) {
            Job_Application__c oldApp = oldMap.get(newApp.Id);

            //*Application Status = 'Saved'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {

                if (oldApp.Application_Status__c == null &&
                    newApp.Application_Status__c == 'Saved') {

                    tasksToInsert.add(createTask(newApp, 'Check if the job description aligns with your interests and values'));
                    tasksToInsert.add(createTask(newApp, 'Review the highlighted skills to see if the role is a good fit'));
                    tasksToInsert.add(createTask(newApp, 'Research the company or role and mark your excitement level'));
                }
            }
                //*Application Status = 'Applying'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {

                    if (oldApp.Application_Status__c == 'Saved' &&
                            newApp.Application_Status__c == 'Applying') {

                    tasksToInsert.add(createTask(newApp, 'Find and research someone who works at the company and add them as a contact'));
                    tasksToInsert.add(createTask(newApp, 'Set up an informational interview to learn more about the role/company'));
                    tasksToInsert.add(createTask(newApp, 'Identify potential referrals to help get your application on the top of the pile'));
                    tasksToInsert.add(createTask(newApp, 'Customize your work achievements using the job description keywords'));
                    tasksToInsert.add(createTask(newApp, 'Submit your application on the company website if possible'));
            }
        }
             //*Application Status = 'Applied'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {

                    if (oldApp.Application_Status__c == 'Applying' &&
                            newApp.Application_Status__c == 'Applied') {

                    tasksToInsert.add(createTask(newApp, 'Reach out to the hiring manager or recruiter'));
                    tasksToInsert.add(createTask(newApp, 'Follow up on your application via email weekly'));
                    tasksToInsert.add(createTask(newApp, 'Continue identifying and saving similar job opportunities'));
                    tasksToInsert.add(createTask(newApp, 'Set up weekly networking calls to explore similar companies/roles'));
                    
            }
        }
           //*Application Status = 'Interviewing'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {

                    if (oldApp.Application_Status__c == 'Applied' &&
                            newApp.Application_Status__c == 'Interviewing') {

                    tasksToInsert.add(createTask(newApp, 'Prepare your blurb or “tell me about yourself” response'));
                    tasksToInsert.add(createTask(newApp, 'Practice answering behavioral interview questions'));
                    tasksToInsert.add(createTask(newApp, 'Research the company and your interviewers'));
                    tasksToInsert.add(createTask(newApp, 'Set up your virtual interview space and test your tech'));
                    tasksToInsert.add(createTask(newApp, 'Send thank you emails within 24 hours'));
            }
        }
         //*Application Status = 'Negotiating'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {

                    if (oldApp.Application_Status__c == 'Interviewing' &&
                            newApp.Application_Status__c == 'Negotiating') {

                    tasksToInsert.add(createTask(newApp, 'Research your market value and know your numbers'));
                    tasksToInsert.add(createTask(newApp, 'Prepare your negotiation scripts'));
                    tasksToInsert.add(createTask(newApp, 'Evaluate your offer and decline or accept'));

            }
        }
        //*Application Status = 'Accepted'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {

                    if (oldApp.Application_Status__c == 'Negotiating' &&
                            newApp.Application_Status__c == 'Accepted') {

                    tasksToInsert.add(createTask(newApp, 'Plan your resignation if applicable'));
                    tasksToInsert.add(createTask(newApp, 'Take some time to relax and recharge'));
                    tasksToInsert.add(createTask(newApp, 'Prepare for your first day of onboarding'));
            }
        }
        //*Application Status = 'Closed'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {

                    if (oldApp.Application_Status__c == 'Accepted' &&
                            newApp.Application_Status__c == 'Closed') {

                    tasksToInsert.add(createTask(newApp, 'Send a follow-up email thanking the interviewer and asking for feedback'));
                    tasksToInsert.add(createTask(newApp, 'Review your notes and reflect on areas of improvement'));
            }
        }
    }
}
        //Bulk insert tasks
        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert; 
        }
    }
    //Create task 
    private static Task createTask(JoB_Application__c app, String subject) {
        Task t = new Task();
        t.Subject = subject;
        t.WhatId = app.Id;
        t.OwnerId = app.OwnerId;
        t.ActivityDate = Date.today().addDays(3);
        t.Priority = 'High';
        return t; 
    }
}
    
 //CLJ