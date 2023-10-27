@isTest
public class RepaymentActualTriggerTest {
    @isTest
    public static void calculateTotalRepaidAmountTest(){
        
        List<Loan__c> loans = new List<Loan__c>();
        List<Repayment_Schedule__c> schedules = new List<Repayment_Schedule__c>();
        List<Repayment_Actual__c> actuals = new List<Repayment_Actual__c>();
        
        Loan__c loan = new Loan__c(Name = 'Test Loan', Loan_Stage__c = 'New', Tenure__c = 3 , Loan_Amount__c = 100000);
        loans.add(loan);
        
        Repayment_Schedule__c schedule1 = new Repayment_Schedule__c(Loan__c = loan.Id, Repayment_Amount__c = 1000, Repayment_Date__c = System.today());
        //Repayment_Schedule__c schedule2 = new Repayment_Schedule__c(Loan__c = loan.Id, Repayment_Amount__c = 2000, Repayment_Date__c = System.today().addMonths(2));
        schedules.add(schedule1);
        //schedules.add(schedule2);
        
        Repayment_Actual__c repayment1 = new Repayment_Actual__c(Loan__c = loan.Id, Repayment_Schedule__c = schedule1.Id, Amount_Deposited__c = 1000, Actual_Repayment_Date__c = System.today());
        //Repayment_Actual__c repayment2 = new Repayment_Actual__c(Loan__c = loan.Id, Repayment_Schedule__c = schedule2.Id, Amount_Deposited__c = 2000, Actual_Repayment_Date__c = System.today().addMonths(2));
        actuals.add(repayment1);
        //actuals.add(repayment2);
        
        insert loans;
        insert schedules;
        insert actuals;
        
        Test.startTest();
        
        Repayment_Schedule__c schedule2 = new Repayment_Schedule__c(Loan__c = loan.Id, Repayment_Amount__c = 2000, Repayment_Date__c = System.today().addMonths(2));
        schedules.add(schedule2);
        
        Repayment_Actual__c repayment2 = new Repayment_Actual__c(Loan__c = loan.Id, Repayment_Schedule__c = schedule2.Id, Amount_Deposited__c = 2000, Actual_Repayment_Date__c = System.today().addMonths(2));
        actuals.add(repayment2);
        
        TotalRepaidAmountHandler.calculateTotalRepaidAmount(actuals, new List<Repayment_Actual__c>(), false);
        
        Test.stopTest();
        
        List<Loan__c> updatedLoans = [SELECT Id, Total_Repaid_Amount__c FROM Loan__c WHERE Id = :loan.Id];
        System.assertEquals(3000, updatedLoans[0].Total_Repaid_Amount__c);
        
        List<Repayment_Schedule__c> rs = [select Id, Missed__c from Repayment_Schedule__c where Id = :schedule1.Id];
        System.assertEquals(false, rs[0].Missed__c);
    }
}