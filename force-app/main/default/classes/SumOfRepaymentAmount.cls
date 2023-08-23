public class SumOfRepaymentAmount {
    public static void validateTotalRepaymentAmount(List<Repayment_Schedule__c> newSchedules, List<Repayment_Schedule__c> oldSchedules, System.TriggerOperation operation) {
        Set<Id> loanIds = new Set<Id>();
        Map<Id, Decimal> loanToTotalRepaymentMap = new Map<Id, Decimal>();
        for (Repayment_Schedule__c schedule : newSchedules) {
            if (schedule.Loan__c != null && schedule.Repayment_Amount__c != null) {
                loanIds.add(schedule.Loan__c);
                if (!loanToTotalRepaymentMap.containsKey(schedule.Loan__c)) {
                    loanToTotalRepaymentMap.put(schedule.Loan__c, schedule.Repayment_Amount__c);
                } else {
                    loanToTotalRepaymentMap.put(schedule.Loan__c, loanToTotalRepaymentMap.get(schedule.Loan__c) + schedule.Repayment_Amount__c);
                }
            }
        }
        if (operation == System.TriggerOperation.BEFORE_DELETE || operation == System.TriggerOperation.BEFORE_UPDATE) {
            for (Repayment_Schedule__c schedule : oldSchedules) {
                if (schedule.Loan__c != null && schedule.Repayment_Amount__c != null) {
                    loanToTotalRepaymentMap.put(schedule.Loan__c, loanToTotalRepaymentMap.get(schedule.Loan__c) - schedule.Repayment_Amount__c);
                }
            }
        }        
        for (Loan__c loan : [SELECT Id, Total_Amount__c FROM Loan__c WHERE Id IN :loanIds]) {
            if (loanToTotalRepaymentMap.containsKey(loan.Id) && loanToTotalRepaymentMap.get(loan.Id) > loan.Total_Amount__c) {
                for (Repayment_Schedule__c schedule : newSchedules) {
                    if (schedule.Loan__c == loan.Id) {
                        schedule.Repayment_Amount__c.addError('Total repayment amount exceeds the total amount on the loan.');
                    }
                }
            }
        }
    }
}