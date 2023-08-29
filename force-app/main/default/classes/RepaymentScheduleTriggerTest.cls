@isTest
public class RepaymentScheduleTriggerTest {
    @isTest
    public static void testHandlers() {
        Loan__c testLoan = new Loan__c(Loan_Amount__c = 100000, Loan_Stage__c = 'New', Tenure__c = 3);
        insert testLoan;
        
        Repayment_Schedule__c testSchedule = new Repayment_Schedule__c(Loan__c = testLoan.Id, Repayment_Date__c = System.today(), Repayment_Amount__c = 5000);
        insert testSchedule;
        
        /*Repayment_Actual__c testRepayment = new Repayment_Actual__c(
            Loan__c = testLoan.Id,
            Repayment_Schedule__c = testSchedule.Id,
            Actual_Repayment_Date__c = System.today().addDays(7),
            Amount_Deposited__c = 5000
        );
        insert testRepayment; */
        
        Test.startTest();
        Repayment_Schedule__c testSchedule1 = new Repayment_Schedule__c(Loan__c = testLoan.Id, Repayment_Date__c = System.today().addDays(2), Repayment_Amount__c = 5000);
        insert testSchedule1;
        Test.stopTest();
        
        
        Loan__c updatedLoan = [SELECT Id FROM Loan__c WHERE Id = :testLoan.Id];
        Repayment_Schedule__c updateRS = [select Id, Repayment_Date__c from Repayment_Schedule__c where ID = :testSchedule.Id];
        //System.assertEquals('Total repayment amount exceeds the total amount on the loan.' );
        //System.assertEquals(true, updateRS.Missed__c);
    }
}