global class JoobleJobScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Call your service
        JoobleJobService.findAndSaveJobs('Salesforce Developer', 'Atlanta, GA', 10);
    }
}
