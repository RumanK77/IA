public class CaseTriggerHandler {
    public static void NumberOfRelatedCases(list<Case> newList, Map<Id, Case> oldMap){
        
        set<Id> accIds = new set<Id>();
        Map<Id, Integer> newCaseCountMap = new Map<Id, Integer>();
        Map<Id, Integer> workingCaseCountMap = new Map<Id, Integer>();
        Map<Id, Integer> escaltedCaseCountMap = new Map<Id, Integer>();
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
        
        if(!newList.isEmpty()){
            for(case newCase : newList){
                if(oldMap != null){
                    Case oldCase = oldMap.get(newCase.Id);
                    if(newCase.AccountId != oldCase.AccountId){
                        accIds.add(oldCase.AccountId);
                        accIds.add(newCase.AccountId);
                    }
                    else if(oldCase.Status != newCase.Status){
                        accIds.add(newCase.AccountId);
                    }
                }
                else{
                    accIds.add(newCase.AccountId);
                }
            }
        }
        if(!accIds.isEmpty()){
            for(Account acc : [select Id, Number_Of_New_Cases__c, Number_Of_Working_Cases__c, Number_Of_Escalated_cases__c,
                               (select Id, Status from Cases) from Account where Id IN : accIds]){
                                   newCaseCountMap.put(acc.Id, 0);
                                   workingCaseCountMap.put(acc.Id, 0);
                                   escaltedCaseCountMap.put(acc.Id, 0);
                                   
                                   for(Case caseObj : acc.Cases){
                                       if(caseObj.Status == 'New'){
                                           newCaseCountMap.put(acc.Id, newCaseCountMap.get(acc.Id) + 1);
                                       }
                                       else if(caseObj.Status == 'Working'){
                                           workingCaseCountMap.put(acc.Id, workingCaseCountMap.get(acc.Id) + 1);
                                       }
                                       else if(caseObj.Status == 'Escalated'){
                                           escaltedCaseCountMap.put(acc.Id, escaltedCaseCountMap.get(acc.Id) + 1);
                                       }
                                   }
                                   if(newCaseCountMap.get(acc.Id) != acc.Number_Of_New_Cases__c || 
                                      workingCaseCountMap.get(acc.Id) != acc.Number_Of_Working_Cases__c ||
                                      escaltedCaseCountMap.get(acc.Id) != acc.Number_Of_Escalated_cases__c)
                                   {
                                       acc.Number_Of_New_Cases__c = newCaseCountMap.get(acc.Id);
                                       acc.Number_Of_Working_Cases__c = workingCaseCountMap.get(acc.Id);
                                       acc.Number_Of_Escalated_cases__c = escaltedCaseCountMap.get(acc.Id);
                                       
                                       accountsToUpdate.put(acc.Id, acc);
                                   }
                               }
            if(!accountsToUpdate.isEmpty()){
                update accountsToUpdate.values();
            }
        }
    }
}