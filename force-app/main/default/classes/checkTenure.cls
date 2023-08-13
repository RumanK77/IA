public class checkTenure implements Database.Batchable<SObject>{
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Tenure__c, (SELECT Id, Repayment_Date__c, Last_Date_of_Repayment__c FROM Repayment_Schedules__r) FROM Loan__c WHERE Tenure__c != null';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<SObject> checkList){
        list<Loan__c> loanList = new list<Loan__c>();
        for(Loan__c ln : loanList){
            Decimal totalTenure = 0;
            for (Repayment_Schedule__c repayment : ln.Repayment_Schedules__r) {
              // totalTenure += repayment.Tenure__c;
            }
            
            if (ln.Tenure__c != totalTenure) {
                loanList.add(ln);
            }
            //sendEmailNotification(loanList);
        }
    }
    
    public void finish(Database.BatchableContext context) {
        
    }
    
    private Decimal calculateTenure(Decimal loanTenure, Date repaymentDate, Date lastDateOfRepayment){
        Integer monthsDifference = calculateMonthsDifference(lastDateOfRepayment, repaymentDate);
        Decimal totalTenure = loanTenure + monthsDifference;
        return totalTenure;
    }
    
    private Integer calculateMonthsDifference(Date date1, Date date2){
        Integer monthsDifference = 0;
        return monthsDifference;
    }
    
    private void sendEmailNotification(List<Loan__c> loansWithMismatch) {
        
    }
}