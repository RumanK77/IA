@isTest
public class RATest {
    static testMethod void method1() {
        String str = JSON.serialize('Actual_Repayment_Date__c, Amount_Deposited__c, Repayment_Schedule__c\n2023-08-11,1000000,a015j00000X7UMRAA3');        
        CreateRepaymentActualRecord.importCSVFile(str);
    } 
}