public class OppoTriggerHandler {
    public static void createNewLoanRecord(list<Opportunity> oppList, Map<Id, Opportunity> oldMap){
        list<Loan__c> loansToCreate = new list<Loan__c>();
        
        for(Opportunity opp : oppList){
            if(opp.StageName == 'Closed Won' && oldMap.get(opp.Id).StageName != 'Closed Won'){
                Loan__c ln = new Loan__c(
                    Loan_Stage__c = 'New',
                    Loan_Amount__c = 1000000,
                    ROI_P_A__c = 8,
                    Tenure__c = 10,
                    Opportunity__c = opp.Id
                );
                loansToCreate.add(ln);
            }
        }
        if(!loansToCreate.isEmpty()){
            insert loansToCreate;
        }
    }
}    

//rumankadri77@mindful-unicorn-mas8iu.com