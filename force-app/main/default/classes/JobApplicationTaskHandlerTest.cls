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
}

