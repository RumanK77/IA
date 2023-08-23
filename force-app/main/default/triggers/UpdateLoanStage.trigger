trigger UpdateLoanStage on Loan__c (After insert, After update) {
    for(Loan__c loan : Trigger.new){
        if(loan.Total_Repaid_Amount__c >= loan.Total_Amount__c){
            loan.Loan_Stage__c = 'Closed';
        }
    }
}