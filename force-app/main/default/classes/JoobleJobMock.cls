@IsTest
global class JoobleJobMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {

        //Create a fake response
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);

        //Fake Jooble API response with jobs
        String fakeBody = '{"jobs": [' +
         '{ "title": "Test Salesforce Developer", "company": "TestCorp", "location": "Remote", "link": "http://example.com/job1" },' +
            '{ "title": "Test Salesforce Admin", "company": "AdminCorp", "location": "Atlanta, GA", "link": "http://example.com/job2" }' +
        '] }';

        res.setBody(fakeBody);
        return res;
    }
}