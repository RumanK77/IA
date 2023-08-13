public class DemoLoanClass {
    @AuraEnabled(Cacheable=true)
    public static list<Loan__c> getdata(){
        list<Loan__c> lList = [select Name, Loan_Stage__c, Loan_Amount__c, Loan_Id__c, ROI_P_A__c, EMI__c, Tenure__c, Total_Amount__c from Loan__c Limit 5];
        return lList;
    }
}