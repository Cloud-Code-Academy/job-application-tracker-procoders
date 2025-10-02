@IsTest
private class JoobleJobSchedulerTest {
    
    @IsTest
    static void testSchedulerRuns() {

        Test.startTest();

        //Use the mock
        Test.setMock(HttpCalloutMock.class, new JoobleJobMock()); 

        
        //Run the scheduler
        JoobleJobScheduler scheduler = new JoobleJobScheduler();
        scheduler.execute(null);
        
        Test.stopTest();

        //Verify jobs got inserted
        List<Job_Application__c> apps = [SELECT Id, Name, Application_Status__c FROM Job_Application__c];
        System.assertEquals(2, apps.size(), 'Two jobs should have been inserted from the mock response');
        System.assertEquals('Saved', apps[0].Application_Status__c, 'Status schould be Saved'); 
        
        //Simple assertion that test completed
        //System.assert(true, 'Scheduler executed without error.');
    }
}
