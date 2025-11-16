public with sharing class JobAppCloseStaleJobsSchedulable implements Schedulable {

    public JobAppCloseStaleJobsSchedulable() {}

    public void execute(System.SchedulableContext sc) {
        Database.executeBatch(new JobAppCloseStaleJobsBatchable(), 2000);
    }

}