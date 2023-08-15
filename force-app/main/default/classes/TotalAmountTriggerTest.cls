@isTest
public class TotalAmountTriggerTest {
    @TestSetup
    static void setupTestData() {
        Loan__c testLoan = new Loan__c(
            Name = 'Test Loan',
            Loan_Amount__c = 10000,
            ROI_P_A__c = 8,
            Tenure__c =5,
            Loan_Stage__c = 'New'
        );
        insert testLoan;
        
        List<Repayment_Schedule__c> testSchedules = new List<Repayment_Schedule__c>{
            new Repayment_Schedule__c(
                Loan__c = testLoan.Id,
                Repayment_Amount__c = 30000
            ),
                new Repayment_Schedule__c(
                    Loan__c = testLoan.Id,
                    Repayment_Amount__c = 4000
                ),
                new Repayment_Schedule__c(
                    Loan__c = testLoan.Id,
                    Repayment_Amount__c = 2000
                )
                };
                    insert testSchedules;
    }
    
    @IsTest
    static void testRepaymentScheduleValidation() {
        Loan__c testLoan = [SELECT Id FROM Loan__c LIMIT 1];
        Repayment_Schedule__c invalidSchedule = new Repayment_Schedule__c(
            Loan__c = testLoan.Id,
            Repayment_Amount__c = 6000
        );
        
        Test.startTest();
        try {
            insert invalidSchedule;
            System.assert(false, 'Expected DmlException but no exception was thrown');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Sum of Repayment Amounts cannot exceed Total Amount on the associated Loan'));
        }
        Test.stopTest();
    }
}