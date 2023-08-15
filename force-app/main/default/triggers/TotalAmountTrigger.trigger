trigger TotalAmountTrigger on Repayment_Schedule__c (before insert, before update) {
    set<Id> loanIds = new set<Id>();
    for(Repayment_Schedule__c schedule : Trigger.new){
        if(schedule.Loan__c != null){
            loanIds.add(schedule.Loan__c);
        }
    }
    if(!loanIds.isEmpty()){
        Map<Id, Loan__c> loansMap = new Map<Id, Loan__c>(
            [select Id, Total_Amount__c, 
             (select Id, Repayment_Amount__c from Repayment_schedules__r where Repayment_Amount__c >0) 
             from Loan__c where Id IN : loanIds]);
        
        for(Repayment_schedule__c schedule : Trigger.new){
            if(loansMap.containsKey(schedule.Loan__c)){
                Loan__c loan = loansMap.get(schedule.Loan__c);
                Decimal totalRepaymentAmount = 0;
                for(Repayment_schedule__c relatedSchedule : loan.Repayment_schedules__r){
                    totalRepaymentAmount += relatedSchedule.Repayment_Amount__c;
                }
                if(totalRepaymentAmount > loan.Total_Amount__c){
                    schedule.addError('ERROR');
                }
            }
        }
    }
}