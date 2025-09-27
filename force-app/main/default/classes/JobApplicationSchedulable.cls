public with sharing class JobApplicationSchedulable implements Schedulable{
    public void execute(SchedulableContext sc) {
        CleanupStaleJobApplications cleanStaleApps = new CleanupStaleJobApplications();
        cleanStaleApps.after30DaysWithoutInteraction();
        
        Database.executeBatch(new PrimaryContactForJobApplicationBatchable());
    }

    //schedule the PrimaryContactForJobApplicationSchedule for 2am every day
    /*public static void scheduleJob() {
        String cronExpression = '0 0 2 * * ?';
        String jobName = 'PrimaryContactForJobApplicationSchedule';
        System.schedule(jobName, cronExpression, new PrimaryContactForJobApplicationSchedule());
    }
    */
}