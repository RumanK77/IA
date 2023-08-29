@isTest
public class RepaymentActualTest {
    @isTest
    static void testHandlers() {
        Loan__c testLoan = new Loan__c(Loan_Amount__c = 100000, Loan_Stage__c = 'New', Tenure__c = 3);
        insert testLoan;
        
        Repayment_Schedule__c testSchedule = new Repayment_Schedule__c(Loan__c = testLoan.Id, Repayment_Date__c = System.today(), Repayment_Amount__c = 5000);
        insert testSchedule;
        
        Repayment_Actual__c testRepayment = new Repayment_Actual__c(
            Loan__c = testLoan.Id,
            Repayment_Schedule__c = testSchedule.Id,
            Actual_Repayment_Date__c = System.today().addDays(7),
            Amount_Deposited__c = 5000
        );
        insert testRepayment;
        
        //List<Repayment_Actual__c> testRepaymentsList = new List<Repayment_Actual__c>();
        //testRepaymentsList.add(testRepayment);
        //TotalRepaidAmountHandler.calculateTotalRepaidAmount(testRepaymentsList, new List<Repayment_Actual__c>(), false);
        
        //List<Repayment_Actual__c> testNewRepaymentsList = new List<Repayment_Actual__c>();
        //testNewRepaymentsList.add(testRepayment);
        //MissedCheckboxHandler.updateMissedCheckbox(testNewRepaymentsList);
        
        Loan__c updatedLoan = [SELECT Id, Total_Repaid_Amount__c FROM Loan__c WHERE Id = :testLoan.Id];
        Repayment_Schedule__c updateRS = [select Id, Missed__c from Repayment_Schedule__c where ID = :testSchedule.Id];
        System.assertEquals(5000, updatedLoan.Total_Repaid_Amount__c);
        System.assertEquals(true, updateRS.Missed__c);
    }
}