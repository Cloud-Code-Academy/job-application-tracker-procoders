public with sharing class JobApplicationTaskHandler {

    // TODO: pull all CMDTs and filter them
    // IDEA: query based on Status__c and Active__c
    // OR
    // IDEA: getAll() then use for loops and maps to filter
    //  if !Active__c continue;
    //  then put into Map<String, List<Job_App_Task_Config__mdt>> for current status

    // TODO: create Custom Metadata Types + Records to store data about Task Configuration
    // Job_App_Task_Config__mdt
    // Active__c = true/false
    // Status__c = 'string'
    // Subject__c = 'string'
    // Priority__c = 'High'/'Medium'/'Low'
    // Activity_Days_From_Insert__c = Decimal

    public static final Map<String, List<String>> JOB_APP_STATUS_TO_TASK_SUBJECT_MAP = new Map<String, List<String>>{
        'Saved' => new List<String>{
            'Check if the job description aligns with your interests and values',
            'Review the highlighted skills to see if the role is a good fit',
            'Research the company or role and mark your excitement level'
        }
    };

    public static void handleAfterInsert(List<Job_Application__c> triggerDotNew) {
        List<Task> tasksForInsert = new List<Task>();
        for(Job_Application__c jobApp : triggerDotNew) {
            tasksForInsert.addAll(createTasks(jobApp));
        }
        Database.insert(tasksToInsert, false);
        // TODO: handle bad task configs
    }

    public static void handleAfterUpdate(List<Job_Application__c> triggerDotNew, Map<Id, Job_Application__c> triggerDotOldMap) {
        // TODO: check if the status of a given Job App has changed
        //  if the status has changed
        //  create and insert the tasks for the new Job Apps in their current status
        List<Task> tasksForInsert = new List<Task>();
        for(Job_Application__c jobApp : triggerDotNew) {
            // if the Status hasn't changed, don't insert new tasks
            if(jobApp.Application_Status__c == triggerDotOldMap.get(jobApp.Id).Application_Status__c) {
                continue;
            }
            // TODO: prevent creating tasks for a "previous" status AND still create tasks if we skip a status
            // IDEA: use validation rule or write code to prevent job apps from going "backwards"
            // IDEA: figure out if the tasks already exist, and don't create them if they exist
            // IDEA: assign a specific numeric value to a status, and if the value of a status goes down, don't create tasks
            tasksForInsert.addAll(createTasks(jobApp));
        }
        Database.insert(tasksToInsert, false);
        // TODO: handle bad task configs?
    }

    public static List<Task> createTasks(Job_Application__c jobApp) {
        List<Task> tasks = new List<Task>();
        switch on jobApp.Application_Status__c {
            // TODO: create the task or tasks
            when 'Saved' {
                for(String taskSubject : JOB_APP_STATUS_TO_TASK_SUBJECT_MAP.get('Saved')) {
                    tasks.add(createTask(jobApp, taskSubject));
                }
                // TODO: use CMDTs??
                /**
                for(Job_App_Task_Config__mdt taskConfig : JOB_APP_STATUS_TO_TASK_CONFIG.get('Saved')) {
                    tasks.add(createTask(jobApp, taskConfig));
                }
                **/
            }
            when 'Applying' {

            }
            when 'Applied' {

            }
            when 'Interviewing' {

            }
            when 'Negotiating' {

            }
            when 'Accepted' {

            }
            when 'Closed' {

            }
            when else {
                
            }
        }
        return tasks;
    }

    private static Task createTask(Job_Application__c jobApp, String subject) {
        Task t = new Task();
        t.Subject = subject;
        t.WhatId = jobApp.Id;
        // TODO: should this be the Job App Owner, or the User working on the Job App?
        //  for example, the OwnerId might be an integration User...
        t.OwnerId = jobApp.OwnerId;
        t.ActivityDate = Date.today().addDays(3);
        t.Priority = 'High';
        return t;
    }

    // TODO: use CMDTs?
    /**
    private static Task createTask(Job_Application__c jobApp, Job_App_Task_Config__mdt taskConfig) {
        Task t = new Task();
        t.Subject = taskConfig.Subject__c;
        t.WhatId = jobApp.Id;
        // TODO: should this be the Job App Owner, or the User working on the Job App?
        //  for example, the OwnerId might be an integration User...
        t.OwnerId = jobApp.OwnerId;
        t.ActivityDate = Date.today().addDays(Integer.valueOf(taskConfig.Activity_Days_From_Insert__c));
        t.Priority = taskConfig.Priority__c;
        return t;
    }
    **/

    // TODO: delete
//     public static void run() {}
        
//         //List that holds task
//         List<Task> tasksToInsert = new List<Task>(); 

//         for(Job_Application__c newApp : newList) {

//         //Check for status change
//         if (isUpdate && oldMap != null) {
//             Job_Application__c oldApp = oldMap.get(newApp.Id);

//             //*Application Status = 'Saved'
//             if (newApp.Application_Status__c != oldApp.Application_Status__c) {

//                 if (oldApp.Application_Status__c == null &&
//                     newApp.Application_Status__c == 'Saved') {

//                     tasksToInsert.add(createTask(newApp, 'Check if the job description aligns with your interests and values'));
//                     tasksToInsert.add(createTask(newApp, 'Review the highlighted skills to see if the role is a good fit'));
//                     tasksToInsert.add(createTask(newApp, 'Research the company or role and mark your excitement level'));
//                 }
//             }
//                 //*Application Status = 'Applying'
//             if (newApp.Application_Status__c != oldApp.Application_Status__c) {

//                     if (oldApp.Application_Status__c == 'Saved' &&
//                             newApp.Application_Status__c == 'Applying') {

//                     tasksToInsert.add(createTask(newApp, 'Find and research someone who works at the company and add them as a contact'));
//                     tasksToInsert.add(createTask(newApp, 'Set up an informational interview to learn more about the role/company'));
//                     tasksToInsert.add(createTask(newApp, 'Identify potential referrals to help get your application on the top of the pile'));
//                     tasksToInsert.add(createTask(newApp, 'Customize your work achievements using the job description keywords'));
//                     tasksToInsert.add(createTask(newApp, 'Submit your application on the company website if possible'));
//             }
//         }
//              //*Application Status = 'Applied'
//             if (newApp.Application_Status__c != oldApp.Application_Status__c) {

//                     if (oldApp.Application_Status__c == 'Applying' &&
//                             newApp.Application_Status__c == 'Applied') {

//                     tasksToInsert.add(createTask(newApp, 'Reach out to the hiring manager or recruiter'));
//                     tasksToInsert.add(createTask(newApp, 'Follow up on your application via email weekly'));
//                     tasksToInsert.add(createTask(newApp, 'Continue identifying and saving similar job opportunities'));
//                     tasksToInsert.add(createTask(newApp, 'Set up weekly networking calls to explore similar companies/roles'));
                    
//             }
//         }
//            //*Application Status = 'Interviewing'
//             if (newApp.Application_Status__c != oldApp.Application_Status__c) {

//                     if (oldApp.Application_Status__c == 'Applied' &&
//                             newApp.Application_Status__c == 'Interviewing') {

//                     tasksToInsert.add(createTask(newApp, 'Prepare your blurb or “tell me about yourself” response'));
//                     tasksToInsert.add(createTask(newApp, 'Practice answering behavioral interview questions'));
//                     tasksToInsert.add(createTask(newApp, 'Research the company and your interviewers'));
//                     tasksToInsert.add(createTask(newApp, 'Set up your virtual interview space and test your tech'));
//                     tasksToInsert.add(createTask(newApp, 'Send thank you emails within 24 hours'));
//             }
//         }
//          //*Application Status = 'Negotiating'
//             if (newApp.Application_Status__c != oldApp.Application_Status__c) {

//                     if (oldApp.Application_Status__c == 'Interviewing' &&
//                             newApp.Application_Status__c == 'Negotiating') {

//                     tasksToInsert.add(createTask(newApp, 'Research your market value and know your numbers'));
//                     tasksToInsert.add(createTask(newApp, 'Prepare your negotiation scripts'));
//                     tasksToInsert.add(createTask(newApp, 'Evaluate your offer and decline or accept'));

//             }
//         }
//         //*Application Status = 'Accepted'
//             if (newApp.Application_Status__c != oldApp.Application_Status__c) {

//                     if (oldApp.Application_Status__c == 'Negotiating' &&
//                             newApp.Application_Status__c == 'Accepted') {

//                     tasksToInsert.add(createTask(newApp, 'Plan your resignation if applicable'));
//                     tasksToInsert.add(createTask(newApp, 'Take some time to relax and recharge'));
//                     tasksToInsert.add(createTask(newApp, 'Prepare for your first day of onboarding'));
//             }
//         }
//         //*Application Status = 'Closed'
//             if (newApp.Application_Status__c != oldApp.Application_Status__c) {

//                     if (oldApp.Application_Status__c == 'Accepted' &&
//                             newApp.Application_Status__c == 'Closed') {

//                     tasksToInsert.add(createTask(newApp, 'Send a follow-up email thanking the interviewer and asking for feedback'));
//                     tasksToInsert.add(createTask(newApp, 'Review your notes and reflect on areas of improvement'));
//             }
//         }
//     }
// }
//         //Bulk insert tasks
//         if (!tasksToInsert.isEmpty()) {
//             insert tasksToInsert; 
//         }
//     }
}