public class TotalRepaidAmountHandler {
    public static void calculateTotalRepaidAmount(list<Repayment_Actual__c> newRepayments, list<Repayment_Actual__c> oldRepayments, Boolean isDelete){
        try{
            set<Id> loanIds = new set<Id>();
            if(!isDelete){
                for (Repayment_Actual__c repayment : newRepayments) {
                    loanIds.add(repayment.Loan__c);
                }  
            }else{
                for (Repayment_Actual__c repayment : oldRepayments) {
                    loanIds.add(repayment.Loan__c);
                }
            }
            
            List<Loan__c> loansToUpdate = new List<Loan__c>();
            
            for (Id loanId : loanIds) {
                List<AggregateResult> aggResult = [
                    SELECT Loan__c, SUM(Amount_Deposited__c) totalAmount
                    FROM Repayment_Actual__c
                    WHERE Loan__c = :loanId
                    GROUP BY Loan__c
                ];
                
                if(!aggResult.isEmpty()){
                    Decimal totalRepaidAmount = (Decimal)aggResult[0].get('totalAmount');
                    loansToUpdate.add(new Loan__c(Id = loanId, Total_Repaid_Amount__c = totalRepaidAmount));
                }
            }
            if(!loansToUpdate.isEmpty()){
                update loansToUpdate;
            }
        }catch(Exception e){
            System.debug('An error occured: ' + e.getMessage());
        }
    }
}