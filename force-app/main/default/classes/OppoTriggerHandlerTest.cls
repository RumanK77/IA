@isTest
public class OppoTriggerHandlerTest {
    @isTest
    static void testCreateNewLoanRecord() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(AccountId = testAccount.Id, FirstName = 'Test', LastName = 'Contact');
        insert testContact;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Closed Won',
            Amount = 1000,
            CloseDate = Date.today(),
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
        oldMap.put(testOpportunity.Id, testOpportunity.clone());

        List<Opportunity> oppList = new List<Opportunity>{testOpportunity};
        OppoTriggerHandler.createNewLoanRecord(oppList, oldMap);

        List<Loan__c> createdLoans = [SELECT Id, Contact__c FROM Loan__c WHERE Contact__c = :testContact.Id];
        System.assertEquals(1, createdLoans.size());
    }
}
//rumankadri77@mindful-unicorn-mas8iu.com