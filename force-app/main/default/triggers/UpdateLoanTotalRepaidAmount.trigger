/*trigger UpdateLoanTotalRepaidAmount on Repayment_Schedule__c (after insert, after update) {
    Set<Id> loanIds = new Set<Id>();
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
    update loansToUpdate;
}*/
trigger UpdateLoanTotalRepaidAmount on Repayment_Schedule__c (after insert, after update) {
    Set<Id> loanIdsToUpdate = new Set<Id>();
    
    for (Repayment_Schedule__c schedule : Trigger.new) {
        loanIdsToUpdate.add(schedule.Loan__c);
    }
    
    List<Loan__c> loansToUpdate = new List<Loan__c>();
    
    for (Id loanId : loanIdsToUpdate) {
        // Calculate the total repaid amount for the loan
        AggregateResult[] results = [SELECT SUM(Repayment_Amount__c) totalRepaid
                                    FROM Repayment_Schedule__c
                                    WHERE Loan__c = :loanId];
        
        Decimal totalRepaidAmount = (Decimal)results[0].get('totalRepaid');
        
        // Retrieve the Loan record
        Loan__c loan = [SELECT Id, Total_Amount__c, Total_Repaid_Amount__c, Loan_Stage__c
                        FROM Loan__c
                        WHERE Id = :loanId];
        
        // Update the Total Repaid Amount field on the Loan
        loan.Total_Repaid_Amount__c = totalRepaidAmount;
        loansToUpdate.add(loan);
        
        // Check if the loan has been fully repaid and update the loan stage if necessary
        if (totalRepaidAmount >= loan.Total_Amount__c) {
            loan.Loan_Stage__c = 'Closed';
            loansToUpdate.add(loan);
        }
    }
    
    if (!loansToUpdate.isEmpty()) {
        update loansToUpdate;
    }
}