public with sharing class JoobleJobService {
    
    public static void findAndSaveJobs(String keyword, String location, Integer maxJobs) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        //Jooble API key
        String apiKey = '446a359a-10eb-4c58-be23-2cf9a158c0b6'; 

        //Jooble Request
        req.setEndpoint('https://jooble.org/api/' + apiKey);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        String body = JSON.serialize(new Map<String, Object>{
            'keywords' => keyword,
            'location' => location
        });

        req.setBody(body);

        HttpResponse res = http.send(req);

        //System.debug('Response status: ' + res.getStatus());

        if (res.getStatusCode() == 200) {
            Map<String, Object> result = 
                (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

            List<Object> jobs = (List<Object>) result.get('jobs');

            List<Job_Application__c> appsToInsert = new List<Job_Application__c>();
            
            List<Account> accountsToInsert = new List<Account>();

            Map<String, Id> companyNameToId = new Map<String, Id>();

            for (Integer i = 0; i < Math.min(3, jobs.size()); i++) {
                Map<String, Object> job = (Map<String, Object>) jobs[i];
                String companyName = (String) job.get('company');

                Id accountId;

                if (String.isNotBlank(companyName)) {

                    //Check cache first to avoid duplicate SOQL
                    if (companyNameToId.containsKey(companyName)) {
                        accountId = companyNameToId.get(companyName);
                    } else {
                        
                        List<Account> existingAcc = [
                            SELECT Id FROM Account WHERE Name = :companyName LIMIT 1
                        ];

                        if (!existingAcc.isEmpty()) {
                            accountId = existingAcc[0].Id;
                        } else {
                            Account newAcc = new Account(Name = companyName);
                            accountsToInsert.add(newAcc);
                        }
                    }
                }

                //Create Job Application
                Job_Application__c app = new Job_Application__c(
                    Name = (String) job.get('title'),
                    Location__c = (String) job.get('location'),
                    URL__c = (String) job.get('link'),
                    Application_Status__c = 'Saved'
                );

                //Temporarily store company name
                if (String.isNotBlank(companyName)) {
                    app.Description__c = companyName;
                }

                appsToInsert.add(app);
            }
            //Insert any new Accounts first
            if (!accountsToInsert.isEmpty()) {
                insert accountsToInsert;
                for (Account acc : accountsToInsert) {
                    companyNameToId.put(acc.Name, acc.Id);
                }
            }

            //Now update Job Applications
            for (Job_Application__c app : appsToInsert) {
                if (String.isNotBlank(app.Description__c) 
                    && companyNameToId.containsKey(app.Description__c)) {
                    app.Company_Name__c = companyNameToId.get(app.Description__c);
                    app.Description__c = null; 
                }
            }

            //
            if (!appsToInsert.isEmpty()) {
                insert appsToInsert;
                System.debug(appsToInsert.size() + ' jobs saved as Job Applications');
            }
        }
    }
}
//CLJ
