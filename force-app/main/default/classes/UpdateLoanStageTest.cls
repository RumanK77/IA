@isTest
public class UpdateLoanStageTest {
    @isTest
    public static void fullyPaidLoan(){
        Loan__c loan = new Loan__c(
            Name = 'check Loan',
            Loan_Amount__c = 1000,
            Tenure__c = 1,
            Loan_Stage__c = 'New'
        );
        insert loan;
        
        Repayment_Schedule__c RS= new Repayment_Schedule__c(
            Loan__c = loan.Id,
            Repayment_Date__c = System.today(),
            Repayment_Amount__c = 1000
        );
        insert RS;
        
        Repayment_Actual__c RA= new Repayment_Actual__c(
            Loan__c = loan.Id,
            Repayment_Schedule__c = RS.Id,
            Actual_Repayment_Date__c = System.today(),
            Amount_Deposited__c = 1000
        );
        insert RA;
        
        Repayment_Schedule__c RS1= new Repayment_Schedule__c(
            Loan__c = loan.Id,
            Repayment_Date__c = System.today(),
            Repayment_Amount__c = 1000
        );
        insert RS1;
        
        Repayment_Actual__c RA1= new Repayment_Actual__c(
            Loan__c = loan.Id,
            Repayment_Schedule__c = RS.Id,
            Actual_Repayment_Date__c = System.today(),
            Amount_Deposited__c = 1000
        );
        insert RA1;
        
        loan = [select Loan_Stage__c from Loan__c where Id =: loan.Id];
        System.assertEquals('Closed', loan.Loan_Stage__c);
    }
}