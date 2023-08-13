@isTest
public class OppoTriggerHandlerTest {
    @isTest
    public Static void createNewLoanRecordTest(){
        Opportunity opp = new Opportunity(
            Name = 'Test Oppo',
            StageName = 'Open',
            CloseDate = System.today()
        );
        insert opp;   
        
        Test.startTest();
        opp.StageName = 'CLosed Won';
        update opp;
        Test.stopTest();
        
        list<Loan__c> loanList = [select Id, Loan__c.Opportunity__c from Loan__c where Opportunity__c =: opp.Id];
        System.assertEquals(opp.Id, loanList[0].Opportunity__c);
    }  
}