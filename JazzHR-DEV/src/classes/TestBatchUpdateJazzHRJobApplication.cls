// Date : 6/62019
// Purpose : Test class to to test BatchUpdateJazzHRJobApplication 
@isTest
public class TestBatchUpdateJazzHRJobApplication {
    public static testMethod void testUpdateJazzHRBatch(){
        
        Job_Listing__c jobs = new Job_Listing__c();
        jobs.JazzHR_Job_ID__c = 'job_20190528092938_NXYBIF7I0NFVY2DA';
        jobs.Status__c = 'Open';
        insert jobs;
        
        Test.startTest();
        HttpMockGenerator jazzHRJobApplicationHttpMockResp = new HttpMockGenerator(200,'Complete','[{"id":"projob_20190606075833_SYJRSEVSEOE55EGJ","applicant_id":"prospect_20190606075833_WD0X3SRPOXMZWSD6","job_id":"job_20190528092938_NXYBIF7I0NFVY2DA","rating":"0","workflow_step_id":"1","date":"0000-00-00"}]');
        Test.setMock(HttpCalloutMock.class, jazzHRJobApplicationHttpMockResp);
        BatchUpdateJazzHRJobApplication jobApplicationBatchObj = new BatchUpdateJazzHRJobApplication();
        database.executeBatch(jobApplicationBatchObj);
        Test.stopTest();           
    }
}