/* Date: 27-feb-2019
* Creator: Vinit/Sachin
* Purpose: This batch can be used for One time activity or For schedulable to link all Enquiry records to corrosponding Applicants
* Email on enquiry/lead is matched with Applicants and applicant is then categorised as Talent Pool Applicant if enquiry exists.
*/

global class BatchLinkEnquiryToApplicants implements 
Database.Batchable<sObject>, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        /*try
{   

}
catch(Exception oEx)
{
Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage(), 'BatchLinkEnquiryToApplicants.Start', null);    
return null;
}
*/
        //Get All Applicants in chunks of 200 with Email Id and start the batch.
        string query = 'SELECT Id, Email__c, Enquiry__c, Type__c From Applicant__c Where Email__c != null';
        return Database.getQueryLocator(query);
    }
    
    //Process the applicant records and associate them to correct enquiry if enquiry exists
    global void execute(Database.BatchableContext bc, List<Applicant__c> scope){
        try
        {
            Set<String> ApplicantEmailsSet = new Set<String>();
            
            For(Applicant__c currentApplicant: scope)
            {
                If(currentApplicant.Email__c !=null)
                {
                    ApplicantEmailsSet.add(currentApplicant.Email__c);
                }
            }
            List<Lead> EnquiryList = new List<Lead> ();
            Map<string, id> EmailEnquiryMap = new Map<string, id>();
            //Get all Enquiries and prepare map to be used when scanning through applicant later.
            EnquiryList = [SELECT Id, Email From Lead Where Email =: ApplicantEmailsSet Order By CreatedDate ASC];
            system.debug('EnquiryList Size: ' + EnquiryList.size());
            For(Lead currentLead: EnquiryList)
            {
                EmailEnquiryMap.put(currentLead.Email, currentLead.Id);
            }            
            system.debug('EmailEnquiryMap Size:' + EmailEnquiryMap.size());

            List<Applicant__c> ApplicantsToUpdate = new List<Applicant__c>();
            For(Applicant__c currentApplicant: scope)
            {
                If(EmailEnquiryMap.get(currentApplicant.Email__c) !=null)
                {
                    currentApplicant.Enquiry__c = EmailEnquiryMap.get(currentApplicant.Email__c);
                    currentApplicant.Type__c = 'TalentPool';
                    ApplicantsToUpdate.add(currentApplicant);
                }
            }
            
            system.debug('ApplicantsToUpdate size: ' + ApplicantsToUpdate.size());
            //Update the applicants
            If(ApplicantsToUpdate.size()>0)
                update ApplicantsToUpdate;
        }
        catch(Exception oEx)
        {
            Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage(), 'BatchLinkEnquiryToApplicants.Execute', null);    
        }
    } 
    
    global void finish(Database.BatchableContext bc){
        try
        {
            system.debug('Inside BatchLinkEnquiryToApplicants Finish');   
        }
        catch(Exception oEx)
        {
            Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage(), 'BatchLinkEnquiryToApplicants.Finish', null);    
        }
    }    
}