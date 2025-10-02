@IsTest
private class InterviewReminderSchedulerTest {

    @IsTest
    static void testSchedulerRuns() {
        
        //Test user with a valid email
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'Scheduler',
            Email = 'testuser@example.com',
            Alias = 'tstsch',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testscheduler' + System.currentTimeMillis() + '@example.com'
        );
        insert testUser;

        //Setup Job Application
        Job_Application__c app = new Job_Application__c(
            Name = 'Test Application',
            Application_Status__c = 'Interviewing'
        );
        insert app;
        
        //Setup event
        Date tomorrow = Date.today().addDays(1);
        Event ev = new Event(
            Subject = 'Interview with Hiring Manager', 
            StartDateTime = DateTime.newInstance(tomorrow, Time.newInstance(9, 0, 0, 0)),
            EndDateTime   = DateTime.newInstance(tomorrow, Time.newInstance(10, 0, 0, 0)),
            WhatId        = app.Id, 
            OwnerId       = testUser.Id, 
            Location      = 'Test Location',
            Description   = 'Test Description'
        ); 
        insert ev;

        Test.startTest();

        InterviewReminderScheduler scheduler = new InterviewReminderScheduler();
        scheduler.execute(null);

        Test.stopTest();

        //Get the actual key prefix for Job_Application__c
        String jobApplicationPrefix = Job_Application__c.SObjectType.getDescribe().getKeyPrefix();

        //Assert the email count based on whether the condition in the scheduler was met
        System.assertEquals(1, InterviewReminderScheduler.lastEmailCount, 'Expected one Interview reminder email to be created.');
        }
    }

