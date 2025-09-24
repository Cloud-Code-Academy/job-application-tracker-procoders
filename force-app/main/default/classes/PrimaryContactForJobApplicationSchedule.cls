public with sharing class PrimaryContactForJobApplicationSchedule implements Schedulable{
    public void execute(SchedulableContext sc) {
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