public class RepaymentScheduleTriggerHandler {
    public static void checkRepaymentDateMonth(list<Repayment_Schedule__c> newSchedules){
        Map<Id, Set<Integer>> loanToMonthsMap = new Map<Id, Set<Integer>>();
        
        set<Id> loanIds = new set<Id>();
        for(Repayment_Schedule__c schedule : newSchedules){
            if(schedule.Loan__c != null){
                loanIds.add(schedule.Loan__c);
            }
        }
        Map<Id, list<Repayment_Schedule__c>> loanToSchedulesMap = new Map<Id, list<Repayment_Schedule__c>>();
        for(Repayment_Schedule__c existingSchedule : [
            select id, Loan__c, Repayment_date__c
            from Repayment_Schedule__c 
            where Loan__c IN :loanIds
        ]) {
            if (!loanToSchedulesMap.containsKey(existingSchedule.Loan__c)) {
                loanToSchedulesMap.put(existingSchedule.Loan__c, new list<Repayment_Schedule__c>{existingSchedule});
            } else {
                loanToSchedulesMap.get(existingSchedule.Loan__c).add(existingSchedule);
            } 
        }
        for (Repayment_Schedule__c newSchedule : newSchedules) {
            if (newSchedule.Loan__c != null && newSchedule.Repayment_Date__c != null) {
                Integer repaymentMonth = newSchedule.Repayment_Date__c.month();
                
                if (loanToSchedulesMap.containsKey(newSchedule.Loan__c)) {
                    for (Repayment_Schedule__c existingSchedule : loanToSchedulesMap.get(newSchedule.Loan__c)) {
                        if (existingSchedule.Id != newSchedule.Id && existingSchedule.Repayment_Date__c.month() == repaymentMonth) {
                            newSchedule.Repayment_Date__c.addError('Repayment dates must be on different months for the same loan.');
                            break;
                        }
                    }
                }
            }
        }
    }
}