@isTest
public class TotalRepaidAmountTriggerTest {
    @TestSetup
    static void setupTestData() {
        Loan__c testLoan = new Loan__c(Name = 'Test Loan', Loan_Stage__c = 'New', Loan_Amount__c = 10000, Tenure__c = 5);
        insert testLoan;
        
        List<Repayment_Actual__c> testRepaymentActuals = new List<Repayment_Actual__c>();
        testRepaymentActuals.add(new Repayment_Actual__c(
            Actual_Repayment_Date__c = Date.today(),
            Amount_Deposited__c = 2000,
            Loan__c = testLoan.Id
        ));
        testRepaymentActuals.add(new Repayment_Actual__c(
            Actual_Repayment_Date__c = Date.today(),
            Amount_Deposited__c = 3000,
            Loan__c = testLoan.Id
        ));
        insert testRepaymentActuals;
    }
    
    @isTest
    static void testUpdateLoanTotalRepaidAmount() {
        Loan__c testLoan = [SELECT Id, Total_Repaid_Amount__c FROM Loan__c LIMIT 1];
        System.assertEquals(5000, testLoan.Total_Repaid_Amount__c);
        Repayment_Actual__c newRepayment = new Repayment_Actual__c(
            Actual_Repayment_Date__c = Date.today(),
            Amount_Deposited__c = 2500,
            Loan__c = testLoan.Id
        );
        insert newRepayment;
        
        testLoan = [SELECT Id, Total_Repaid_Amount__c FROM Loan__c WHERE Id = :testLoan.Id];
        System.assertEquals(7500, testLoan.Total_Repaid_Amount__c);
        
        delete newRepayment;
        
        testLoan = [SELECT Id, Total_Repaid_Amount__c FROM Loan__c WHERE Id = :testLoan.Id];
        System.assertEquals(5000, testLoan.Total_Repaid_Amount__c);
    }
}