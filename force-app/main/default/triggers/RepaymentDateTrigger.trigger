trigger RepaymentDateTrigger on Repayment_Schedule__c (before insert, before update) {
    Map<Id, Set<Integer>> loanIdToMonths = new Map<Id, Set<Integer>>();
    for(Repayment_Schedule__c repayment : Trigger.new){
        if(repayment.Repayment_Date__c != null && repayment.Loan__c != null){
            Integer repaymentMonth = repayment.Repayment_Date__c.month();
            if(!loanIdToMonths.containsKey(repayment.Loan__c)){
                loanIdToMonths.put(repayment.Loan__c, new Set<Integer>());
            }            
            Set<Integer> months = loanIdToMonths.get(repayment.Loan__c);
            if(months.contains(repaymentMonth)){
                repayment.addError('ERROR');
            }else{
                months.add(repaymentMonth);
                loanIdToMonths.put(repayment.Loan__c, months);
            }
        }
    }
}