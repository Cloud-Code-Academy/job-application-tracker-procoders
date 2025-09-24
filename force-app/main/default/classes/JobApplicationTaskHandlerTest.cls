@IsTest
public with sharing class JobApplicationTaskHandlerTest {
    @IsTest
    static void testBlankToSaved_createsTasks() {
        // 1. Create a Job Application with no status
        Job_Application__c app = new Job_Application__c(
            Name = 'Test App',
            Application_Status__c = null
        );
        insert app;

        // 2. Update status to 'Saved'
        app.Application_Status__c = 'Saved';
        update app;

        // 3. Query for tasks created
        List<Task> tasks = [
            SELECT Subject, WhatId, Priority
            FROM Task
            WHERE WhatId = :app.Id
        ];

        // 4. Assert that the right number of tasks were created
        System.assertEquals(3, tasks.size(), 'Three tasks should be created for Saved status');

        // 5. Assert one of the subjects to make sure it’s correct
        System.assertEquals('Check if the job description aligns with your interests and values',
            tasks[0].Subject
        );
    }
    @IsTest
    static void testSavedToApplying() {
        //1. Update a Job Application
        Job_Application__c app = new Job_Application__c(
            Name = 'Test App',
            Application_Status__c = 'Saved'
        );
        insert app;

        app.Application_Status__c = 'Applying';
        update app; 
        
        List<Task> tasks = [
            SELECT Subject, WhatId, Priority
            FROM Task
            WHERE WhatId = :app.Id
        ];
        System.assertEquals(5, tasks.size(), 'Five tasks should be created when status changes from Saved to Applying');

        System.assertEquals('Find and research someone who works at the company and add them as a contact',
            tasks[0].Subject
        );
    }
    @IsTest
    static void testSavedToApplied() {
        
        Job_Application__c app = new Job_Application__c(
            Name = 'Test App',
            Application_Status__c = 'Applying'
        );
        insert app;

        app.Application_Status__c = 'Applied';
        update app; 
        
        List<Task> tasks = [
            SELECT Subject, WhatId, Priority
            FROM Task
            WHERE WhatId = :app.Id
        ];
        System.assertEquals(4, tasks.size(), 'Four tasks should be created when status changes from Saved to Applied');

        System.assertEquals('Reach out to the hiring manager or recruiter',
            tasks[0].Subject
        );
    }
    @IsTest
    static void testSavedToInterviewing() {
        
        Job_Application__c app = new Job_Application__c(
            Name = 'Test App',
            Application_Status__c = 'Applied'
        );
        insert app;

        app.Application_Status__c = 'Interviewing';
        update app; 
        
        List<Task> tasks = [
            SELECT Subject, WhatId, Priority
            FROM Task
            WHERE WhatId = :app.Id
        ];
        System.assertEquals(5, tasks.size(), 'Five tasks should be created when status changes from Saved to Applied');

        System.assertEquals('Prepare your blurb or “tell me about yourself” response',
            tasks[0].Subject
        );
    }
    @IsTest
    static void testSavedToNegotiating() {
        
        Job_Application__c app = new Job_Application__c(
            Name = 'Test App',
            Application_Status__c = 'Interviewing'
        );
        insert app;

        app.Application_Status__c = 'Negotiating';
        update app; 
        
        List<Task> tasks = [
            SELECT Subject, WhatId, Priority
            FROM Task
            WHERE WhatId = :app.Id
        ];
        System.assertEquals(3, tasks.size(), 'Three tasks should be created when status changes from Saved to Applied');

        System.assertEquals('Research your market value and know your numbers',
            tasks[0].Subject
        );
    }
    @IsTest
    static void testSavedToAccepted() {
        
        Job_Application__c app = new Job_Application__c(
            Name = 'Test App',
            Application_Status__c = 'Negotiating'
        );
        insert app;

        app.Application_Status__c = 'Accepted';
        update app; 
        
        List<Task> tasks = [
            SELECT Subject, WhatId, Priority
            FROM Task
            WHERE WhatId = :app.Id
        ];
        System.assertEquals(3, tasks.size(), 'Three tasks should be created when status changes from Saved to Applied');

        System.assertEquals('Plan your resignation if applicable',
            tasks[0].Subject
        );
    }
    @IsTest
    static void testSavedToClosed() {
        
        Job_Application__c app = new Job_Application__c(
            Name = 'Test App',
            Application_Status__c = 'Accepted'
        );
        insert app;

        app.Application_Status__c = 'Closed';
        update app; 
        
        List<Task> tasks = [
            SELECT Subject, WhatId, Priority
            FROM Task
            WHERE WhatId = :app.Id
        ];
        System.assertEquals(2, tasks.size(), 'Two tasks should be created when status changes from Saved to Applied');

        System.assertEquals('Send a follow-up email thanking the interviewer and asking for feedback',
            tasks[0].Subject
        );
    }
}

