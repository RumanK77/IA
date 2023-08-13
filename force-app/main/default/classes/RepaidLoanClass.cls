public with sharing class RepaidLoanClass {
    public static void handleAfterInsertUpdate(List<Repayment_Actual__c> raList) {
        Set<Id> loanIds = new Set<Id>();
        
        for (Repayment_Actual__c repaymentActual : raList) {
            loanIds.add(repaymentActual.Loan__c);
        }
        
        if (!loanIds.isEmpty()) {
            List<Loan__c> loansToUpdate = new List<Loan__c>();
            for (Id loanId : loanIds) {
                Decimal totalRepaidAmount = 0;
                for (Repayment_Actual__c repaymentActual : raList) {
                    if (repaymentActual.Loan__c == loanId) {
                        totalRepaidAmount += repaymentActual.Amount_Deposited__c;
                    }
                }
                
                Loan__c loanToUpdate = new Loan__c(Id = loanId);
                if (totalRepaidAmount >= loanToUpdate.Loan_Amount__c) {
                    loanToUpdate.Loan_Stage__c = 'Closed';
                }
                loansToUpdate.add(loanToUpdate);
            }
            update loansToUpdate;
        }
    }
}