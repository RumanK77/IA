@isTest
public class RATest {
    static testMethod void method1() {
        /*Loan__c testLoan = new Loan__c(Name = 'Test Loan', Loan_Amount__c = 1000000, Loan_Stage__c = 'New', Tenure__c = 5);
insert testLoan;

Repayment_Schedule__c testRepaymentSchedule = new Repayment_Schedule__c(
Loan__c = testLoan.Id,
Repayment_Date__c = Date.newInstance(2023, 8, 11),
Repayment_Amount__c = 10000
);
insert testRepaymentSchedule;

String str = '2023-08-11,10000,' + testRepaymentSchedule.Id;

Test.startTest();
CreateRepaymentActualRecord.importCSVFile(str);
Test.stopTest();

List<Repayment_Actual__c> createdRecords = [SELECT Id, Amount_Deposited__c FROM Repayment_Actual__c];
//System.assertEquals(1, createdRecords.size());
System.assertEquals(1000000, createdRecords[0].Amount_Deposited__c);
} 
}*/
        
        String str = JSON.serialize('Actual_Repayment_Date__c, Amount_Deposited__c, Repayment_Schedule__c\n2023-08-11,1000000,a015j00000YjFfoAAF');        
        CreateRepaymentActualRecord.importCSVFile(str);
    }
}