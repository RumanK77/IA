@isTest
public class RepaidLoanClassTest {
    @isTest
    static void testLoanFullyRepaid() {
        Loan__c testLoan = new Loan__c(
            Name = 'Test Loan',
            Loan_Amount__c = 10000,
            Loan_Stage__c = 'New',
            Tenure__c = 10
        );
        insert testLoan;
        
        List<Repayment_Actual__c> testRepaymentActuals = new List<Repayment_Actual__c>();
        testRepaymentActuals.add(new Repayment_Actual__c(
            Actual_Repayment_Date__c = Date.today(),
            Amount_Deposited__c = 5000,
            Loan__c = testLoan.Id
        ));
        insert testRepaymentActuals;
        
        Test.startTest();
        RepaymentActualTriggerHandler.handleAfterInsertUpdate(testRepaymentActuals);
        Test.stopTest();
        
        Loan__c updatedLoan = [SELECT Id, Loan_Stage__c FROM Loan__c WHERE Id = :testLoan.Id];
        
        System.assertEquals('Closed', updatedLoan.Loan_Stage__c);
    }
    
    @isTest
    static void testLoanNotFullyRepaid() {
        Loan__c testLoan = new Loan__c(
            Name = 'Test Loan',
            Loan_Amount__c = 10000,
            Loan_Stage__c = 'New',
            Tenure__c = 10
        );
        insert testLoan;
        
        List<Repayment_Actual__c> testRepaymentActuals = new List<Repayment_Actual__c>();
        testRepaymentActuals.add(new Repayment_Actual__c(
            Actual_Repayment_Date__c = Date.today(),
            Amount_Deposited__c = 5000,
            Loan__c = testLoan.Id
        ));
        insert testRepaymentActuals;
        
        Test.startTest();
        RepaymentActualTriggerHandler.handleAfterInsertUpdate(testRepaymentActuals);
        Test.stopTest();
        
        Loan__c updatedLoan = [SELECT Id, Loan_Stage__c FROM Loan__c WHERE Id = :testLoan.Id];
        
        System.assertEquals('New', updatedLoan.Loan_Stage__c);
    }
}