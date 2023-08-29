public class OppoTriggerHandler {
    public static void createNewLoanRecord(List<Opportunity> oppList, Map<Id, Opportunity> oldMap) {
        List<Loan__c> loansToCreate = new List<Loan__c>();
        
        for (Opportunity opp : oppList) {
            if (opp.StageName == 'Closed Won' && oldMap.get(opp.Id).StageName != 'Closed Won') {
                Account associatedAccount = [SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE Id = :opp.AccountId];
                
                if (associatedAccount != null && !associatedAccount.Contacts.isEmpty()) {
                    Contact associatedContact = associatedAccount.Contacts[0];
                    
                    Loan__c ln = new Loan__c(
                        Loan_Stage__c = 'New',
                        Loan_Amount__c = 1000000,
                        ROI_P_A__c = 8,
                        Tenure__c = 10,
                        Contact__c = associatedContact.Id 
                    );
                    loansToCreate.add(ln);
                }
            }
        }
        if (!loansToCreate.isEmpty()) {
            insert loansToCreate;
        }
    }
}