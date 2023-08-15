public class RepaidLoanClass {
    public static void handleAfterInsertUpdate(List<Loan__c> loans) {
        Set<Id> loanIds = new Set<Id>();
        for (Loan__c loan : loans) {
            loanIds.add(loan.Id);
        }
        
        Map<Id, Decimal> loanAmountDepositedMap = new Map<Id, Decimal>();
        for (AggregateResult result : [ SELECT Loan__c, SUM(Amount_Deposited__c) totalDeposited 
                                       FROM Repayment_Actual__c
                                       WHERE Loan__c IN :loanIds
                                       GROUP BY Loan__c
                                      ]) {
                                          Id loanId = (Id)result.get('Loan__c');
                                          Decimal totalDeposited = (Decimal)result.get('totalDeposited');
                                          loanAmountDepositedMap.put(loanId, totalDeposited);
                                      }
        
        
        List<Loan__c> loansToUpdate = new List<Loan__c>();
        for (Loan__c loan : loans) {
            if (loanAmountDepositedMap.containsKey(loan.Id) &&
                loanAmountDepositedMap.get(loan.Id) >= loan.Total_Amount__c) {
                    loan.Loan_Stage__c = 'Closed';
                    loansToUpdate.add(loan);
                }
        }
        update loansToUpdate; 
    }
}