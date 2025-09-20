public with sharing class JobApplicationTaskHandler {

    public static void run(
        List<Job_Application__c> newList,
        Map<Id, Job_Application__c> oldMap,
        Boolean isInsert,
        Boolean isUpdate
    ) {

        List<Task> tasksToInsert = new List<Task>(); 

        for (Job_Application__c newApp : newList) {

            if (isUpdate && oldMap != null) {
                Job_Application__c oldApp = oldMap.get(newApp.Id);
                
                //*Application Status = 'Saved'
                    if (newApp.Application_Status__c != oldApp.Application_Status__c) {
                    if (oldApp.Application_Status__c == null &&
                            newApp.Application_Status__c == 'Saved') {

                        Task t1 = new Task();
                            t1.Subject = 'Check if the job description aligns with your interests and values';
                            t1.WhatId = newApp.Id;
                            t1.OwnerId = newApp.OwnerId;
                            t1.ActivityDate = Date.today().addDays(3);
                            t1.Priority = 'High';
                            tasksToInsert.add(t1);

                            Task t2 = new Task();
                                t2.Subject = 'Review the highlighted skills to see if the role is a good fit';
                                t2.WhatId = newApp.Id;
                                t2.OwnerId = newApp.OwnerId;
                                t2.ActivityDate = Date.today().addDays(3);
                                t2.Priority = 'High';
                                tasksToInsert.add(t2);

                                Task t3 = new Task();
                                t3.Subject = 'Research the company or role and mark your excitement level';
                                t3.WhatId = newApp.Id;
                                t3.OwnerId = newApp.OwnerId;
                                t3.ActivityDate = Date.today().addDays(3);
                                t3.Priority = 'High';
                                tasksToInsert.add(t3);
}
            }
            //*Application Status = 'Applying'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {
                    if (oldApp.Application_Status__c == 'Saved' &&
                            newApp.Application_Status__c == 'Applying') {

                        Task t1 = new Task();
                            t1.Subject = 'Find and research someone who works at the company and add them as a contact';
                            t1.WhatId = newApp.Id;
                            t1.OwnerId = newApp.OwnerId;
                            t1.ActivityDate = Date.today().addDays(3);
                            t1.Priority = 'High';
                            tasksToInsert.add(t1);

                            Task t2 = new Task();
                                t2.Subject = 'Set up an informational interview to learn more about the role/company';
                                t2.WhatId = newApp.Id;
                                t2.OwnerId = newApp.OwnerId;
                                t2.ActivityDate = Date.today().addDays(3);
                                t2.Priority = 'High';
                                tasksToInsert.add(t2);

                                Task t3 = new Task();
                                t3.Subject = 'Identify potential referrals to help get your application on the top of the pile';
                                t3.WhatId = newApp.Id;
                                t3.OwnerId = newApp.OwnerId;
                                t3.ActivityDate = Date.today().addDays(3);
                                t3.Priority = 'High';
                                tasksToInsert.add(t3);

                                Task t4 = new Task();
                                t4.Subject = 'Customize your work achievements using the job description keywords';
                                t4.WhatId = newApp.Id;
                                t4.OwnerId = newApp.OwnerId;
                                t4.ActivityDate = Date.today().addDays(3);
                                t4.Priority = 'High';
                                tasksToInsert.add(t4);

                                Task t5 = new Task();
                                t5.Subject = 'Submit your application on the company website if possible';
                                t5.WhatId = newApp.Id;
                                t5.OwnerId = newApp.OwnerId;
                                t5.ActivityDate = Date.today().addDays(3);
                                t5.Priority = 'High';
                                tasksToInsert.add(t5);
}
        }
                    //*Application Status = 'Applied'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {
                    if (oldApp.Application_Status__c == 'Applying' &&
                            newApp.Application_Status__c == 'Applied') {

                        Task t1 = new Task();
                            t1.Subject = 'Reach out to the hiring manager or recruiter';
                            t1.WhatId = newApp.Id;
                            t1.OwnerId = newApp.OwnerId;
                            t1.ActivityDate = Date.today().addDays(3);
                            t1.Priority = 'High';
                            tasksToInsert.add(t1);

                            Task t2 = new Task();
                                t2.Subject = 'Follow up on your application via email weekly';
                                t2.WhatId = newApp.Id;
                                t2.OwnerId = newApp.OwnerId;
                                t2.ActivityDate = Date.today().addDays(3);
                                t2.Priority = 'High';
                                tasksToInsert.add(t2);

                                Task t3 = new Task();
                                t3.Subject = 'Continue identifying and saving similar job opportunities';
                                t3.WhatId = newApp.Id;
                                t3.OwnerId = newApp.OwnerId;
                                t3.ActivityDate = Date.today().addDays(3);
                                t3.Priority = 'High';
                                tasksToInsert.add(t3);

                                Task t4 = new Task();
                                t4.Subject = 'Set up weekly networking calls to explore similar companies/roles';
                                t4.WhatId = newApp.Id;
                                t4.OwnerId = newApp.OwnerId;
                                t4.ActivityDate = Date.today().addDays(3);
                                t4.Priority = 'High';
                                tasksToInsert.add(t4);
}
        }
        //*Application Status = 'Interviewing'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {
                    if (oldApp.Application_Status__c == 'Applied' &&
                            newApp.Application_Status__c == 'Interviewing') {

                        Task t1 = new Task();
                            t1.Subject = 'Prepare your blurb or “tell me about yourself” response';
                            t1.WhatId = newApp.Id;
                            t1.OwnerId = newApp.OwnerId;
                            t1.ActivityDate = Date.today().addDays(3);
                            t1.Priority = 'High';
                            tasksToInsert.add(t1);

                            Task t2 = new Task();
                                t2.Subject = 'Practice answering behavioral interview questions';
                                t2.WhatId = newApp.Id;
                                t2.OwnerId = newApp.OwnerId;
                                t2.ActivityDate = Date.today().addDays(3);
                                t2.Priority = 'High';
                                tasksToInsert.add(t2);

                                Task t3 = new Task();
                                t3.Subject = 'Research the company and your interviewers';
                                t3.WhatId = newApp.Id;
                                t3.OwnerId = newApp.OwnerId;
                                t3.ActivityDate = Date.today().addDays(3);
                                t3.Priority = 'High';
                                tasksToInsert.add(t3);

                                Task t4 = new Task();
                                t4.Subject = 'Set up your virtual interview space and test your tech';
                                t4.WhatId = newApp.Id;
                                t4.OwnerId = newApp.OwnerId;
                                t4.ActivityDate = Date.today().addDays(3);
                                t4.Priority = 'High';
                                tasksToInsert.add(t4);

                                Task t5 = new Task();
                                t5.Subject = 'Send thank you emails within 24 hours';
                                t5.WhatId = newApp.Id;
                                t5.OwnerId = newApp.OwnerId;
                                t5.ActivityDate = Date.today().addDays(3);
                                t5.Priority = 'High';
                                tasksToInsert.add(t5);
}
        }
                //*Application Status = 'NEGOTIATING'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {
                    if (oldApp.Application_Status__c == 'Interviewing' &&
                            newApp.Application_Status__c == 'NEGOTIATING') {

                        Task t1 = new Task();
                            t1.Subject = 'Research your market value and know your numbers';
                            t1.WhatId = newApp.Id;
                            t1.OwnerId = newApp.OwnerId;
                            t1.ActivityDate = Date.today().addDays(3);
                            t1.Priority = 'High';
                            tasksToInsert.add(t1);

                            Task t2 = new Task();
                                t2.Subject = 'Prepare your negotiation scripts';
                                t2.WhatId = newApp.Id;
                                t2.OwnerId = newApp.OwnerId;
                                t2.ActivityDate = Date.today().addDays(3);
                                t2.Priority = 'High';
                                tasksToInsert.add(t2);

                                Task t3 = new Task();
                                t3.Subject = 'Evaluate your offer and decline or accept';
                                t3.WhatId = newApp.Id;
                                t3.OwnerId = newApp.OwnerId;
                                t3.ActivityDate = Date.today().addDays(3);
                                t3.Priority = 'High';
                                tasksToInsert.add(t3);
}
        }

                        //*Application Status = 'Accepted'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {
                    if (oldApp.Application_Status__c == 'NEGOTIATING' &&
                            newApp.Application_Status__c == 'Accepted') {

                        Task t1 = new Task();
                            t1.Subject = 'Plan your resignation if applicable';
                            t1.WhatId = newApp.Id;
                            t1.OwnerId = newApp.OwnerId;
                            t1.ActivityDate = Date.today().addDays(3);
                            t1.Priority = 'High';
                            tasksToInsert.add(t1);

                            Task t2 = new Task();
                                t2.Subject = 'Take some time to relax and recharge';
                                t2.WhatId = newApp.Id;
                                t2.OwnerId = newApp.OwnerId;
                                t2.ActivityDate = Date.today().addDays(3);
                                t2.Priority = 'High';
                                tasksToInsert.add(t2);

                                Task t3 = new Task();
                                t3.Subject = 'Prepare for your first day of onboarding';
                                t3.WhatId = newApp.Id;
                                t3.OwnerId = newApp.OwnerId;
                                t3.ActivityDate = Date.today().addDays(3);
                                t3.Priority = 'High';
                                tasksToInsert.add(t3);
}
        }

                                //*Application Status = 'Closed'
            if (newApp.Application_Status__c != oldApp.Application_Status__c) {
                    if (oldApp.Application_Status__c == 'Accepted' &&
                            newApp.Application_Status__c == 'Closed') {

                        Task t1 = new Task();
                            t1.Subject = 'Send a follow-up email thanking the interviewer and asking for feedback';
                            t1.WhatId = newApp.Id;
                            t1.OwnerId = newApp.OwnerId;
                            t1.ActivityDate = Date.today().addDays(3);
                            t1.Priority = 'High';
                            tasksToInsert.add(t1);

                            Task t2 = new Task();
                                t2.Subject = 'Review your notes and reflect on areas of improvement';
                                t2.WhatId = newApp.Id;
                                t2.OwnerId = newApp.OwnerId;
                                t2.ActivityDate = Date.today().addDays(3);
                                t2.Priority = 'High';
                                tasksToInsert.add(t2);
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert; 
        }
    }


}
    }
}
}