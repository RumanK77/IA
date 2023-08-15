@isTest
public class RepaidLoanClassTest {
    
    static testMethod void testFullyRepaidLoan() {
        Loan__c testLoan = new Loan__c(
            Name = 'Test Loan',
            Loan_Stage__c = 'Approved',
            Loan_Amount__c = 10000,
            ROI_P_A__c = 7,
            Tenure__c = 5
        );
        insert testLoan;
        
        List<Repayment_Actual__c> testRepaymentActuals = new List<Repayment_Actual__c>{
            new Repayment_Actual__c(
                Amount_Deposited__c = 5000,
                Loan__c = testLoan.Id
            ),
                new Repayment_Actual__c(
                    Amount_Deposited__c = 5000,
                    Loan__c = testLoan.Id
                )
                };
                    insert testRepaymentActuals;
        
        Test.startTest();
        List<Loan__c> loansToUpdate = new List<Loan__c>{ testLoan };
            RepaidLoanClass.handleAfterInsertUpdate(loansToUpdate);
        Test.stopTest();
        
        Loan__c updatedLoan = [SELECT Id, Loan_Stage__c FROM Loan__c WHERE Id = :testLoan.Id];
        System.assertEquals('Closed', updatedLoan.Loan_Stage__c);
    }
}