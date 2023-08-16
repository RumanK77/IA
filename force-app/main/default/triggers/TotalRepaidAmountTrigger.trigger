trigger TotalRepaidAmountTrigger on Repayment_Actual__c (after insert, after update, after delete) {
    set<Id> loanIds = new set<Id>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for (Repayment_Actual__c repayment : Trigger.new) {
            loanIds.add(repayment.Loan__c);
        }        
    }
    else if (Trigger.isDelete) {
        for (Repayment_Actual__c repayment : Trigger.old) {
            loanIds.add(repayment.Loan__c);
        }
    }
    
    List<Loan__c> loansToUpdate = new List<Loan__c>();
    for (Id loanId : loanIds) {
        List<AggregateResult> aggResult = [
            SELECT Loan__c, SUM(Amount_Deposited__c) totalAmount
            FROM Repayment_Actual__c
            WHERE Loan__c = :loanId
            GROUP BY Loan__c];
        if(!aggResult.isEmpty()){
            Decimal totalRepaidAmount = (Decimal)aggResult[0].get('totalAmount');
            loansToUpdate.add(new Loan__c(Id = loanId, Total_Repaid_Amount__c = totalRepaidAmount));
        }
    }
    if(!loansToUpdate.isEmpty()){
        update loansToUpdate;
    }
}