@isTest
public class TestRepaymentActualTriggerHandler {
    
    static testMethod void testHandleAfterInsertUpdate() {
        Repayment_Schedule__c schedule = new Repayment_Schedule__c(Repayment_Date__c = Date.today(), Repayment_Amount__c = 100000);
        insert schedule;
        
        Repayment_Actual__c repaymentActual = new Repayment_Actual__c(
            Repayment_Schedule__c = schedule.Id,
            Actual_Repayment_Date__c = Date.today().addDays(10)
        );
        
        Test.startTest();
        insert repaymentActual;
        Test.stopTest();
        
        schedule = [SELECT Id, Missed__c FROM Repayment_Schedule__c WHERE Id = :schedule.Id];
        System.assertEquals(true, schedule.Missed__c);
    }
}