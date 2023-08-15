/*@isTest
public class UpdateLoanTotalRepaidAmountTest {
    @isTest
    static void testUpdateTotalRepaidAmount() {
        // Create a test Loan record
        Loan__c testLoan = new Loan__c(Name = 'Test Loan',Loan_Stage__c = 'New', Loan_Amount__c = 10000, Tenure__c = 5, Total_Repaid_Amount__c = 0);
        insert testLoan;
        
        // Create test Repayment Schedule records associated with the test Loan
        List<Repayment_Schedule__c> testSchedules = new List<Repayment_Schedule__c>();
        for (Integer i = 1; i <= 3; i++) {
            testSchedules.add(new Repayment_Schedule__c(
                Loan__c = testLoan.Id,
                Repayment_Amount__c = 1000
            ));
        }
        insert testSchedules;
        
        // Calculate the expected total repaid amount (3000)
        Decimal expectedTotalRepaidAmount = 3000;
        
        // Trigger the update
        Test.startTest();
        update testSchedules;
        Test.stopTest();
        
        // Retrieve the updated Loan record
        testLoan = [SELECT Id, Total_Repaid_Amount__c FROM Loan__c WHERE Id = :testLoan.Id];
        
        // Verify that the Total Repaid Amount field is updated correctly
        System.assertEquals(expectedTotalRepaidAmount, testLoan.Total_Repaid_Amount__c);
    }
} */


@isTest
public class UpdateLoanTotalRepaidAmountTest {
    @isTest
    static void testLoanFullyRepaid() {
        // Create a Loan record
        Loan__c testLoan = new Loan__c(
            Name = 'Work Loan',
            Loan_Stage__c = 'Approved',
            Loan_Amount__c = 10000,
            ROI_P_A__c = 7,
            Tenure__c = 5
        );
        insert testLoan;
        
        // Create Repayment Schedule records
        List<Repayment_Schedule__c> testSchedules = new List<Repayment_Schedule__c>();
        for (Integer i = 1; i <= 5; i++) {
            testSchedules.add(new Repayment_Schedule__c(
                Loan__c = testLoan.Id,
                Repayment_Amount__c = 2000
            ));
        }
        insert testSchedules;
        
        // Trigger the update
        Test.startTest();
        update testSchedules;
        Test.stopTest();
        
        // Verify that the Loan stage is updated to 'Closed'
        Loan__c updatedLoan = [SELECT Id, Loan_Stage__c FROM Loan__c WHERE Id = :testLoan.Id];
        System.assertEquals('Closed', updatedLoan.Loan_Stage__c);
    }
}