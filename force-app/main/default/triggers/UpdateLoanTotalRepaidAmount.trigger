trigger UpdateLoanTotalRepaidAmount on Repayment_Schedule__c (after insert, after update) {
    /*Set<Id> loanIds = new Set<Id>();
    for (Repayment_Schedule__c schedule : Trigger.new) {
        loanIds.add(schedule.Loan__c);
    }
    List<Loan__c> loansToUpdate = new List<Loan__c>();
    for (Id loanId : loanIds) {
        Decimal totalRepaidAmount = 0;
        for (Repayment_Schedule__c schedule : [SELECT Id, Repayment_Amount__c 
                                               FROM Repayment_Schedule__c 
                                               WHERE Loan__c = :loanId]) {
                                                   totalRepaidAmount += schedule.Repayment_Amount__c;
                                               }
        loansToUpdate.add(new Loan__c(
            Id = loanId,
            Total_Repaid_Amount__c = totalRepaidAmount
        ));
    }
    update loansToUpdate;*/
}