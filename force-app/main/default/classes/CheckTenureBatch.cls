public class CheckTenureBatch implements Database.Batchable<SObject>, Database.AllowsCallouts{
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Tenure__c, (SELECT Id, Repayment_Date__c, Last_Date_of_Repayment__c FROM Repayment_Schedules__r) FROM Loan__c WHERE Tenure__c != null';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<SObject> scope) {
        List<Loan__c> loansToUpdate = new List<Loan__c>();
        
        for (Loan__c loanRecord : (List<Loan__c>)scope) {
            Decimal totalTenure = 0;
            for (Repayment_Schedule__c repayment : loanRecord.Repayment_Schedules__r) {
                totalTenure += calculateTenure(loanRecord.Tenure__c, repayment.Repayment_Date__c, repayment.Last_Date_of_Repayment__c);
            }
            
            if (loanRecord.Tenure__c != totalTenure) {
                loansToUpdate.add(loanRecord);
            }
        }
        
        update loansToUpdate;
        
        // Send email notification for the mismatches
        sendEmailNotification(loansToUpdate);
    }
    
    public void finish(Database.BatchableContext context) {
        // Optionally, add any post-processing logic here
    }
    
    // Method to calculate the tenure based on Loan's tenure, Repayment Date, and Last Date of Repayment
    // Method to calculate the tenure based on Loan's tenure, Repayment Date, and Last Date of Repayment
    private Decimal calculateTenure(Decimal loanTenure, Date repaymentDate, Date lastDateOfRepayment) {
        // Calculate the difference in months between lastDateOfRepayment and repaymentDate
        Integer monthsDifference = calculateMonthsDifference(lastDateOfRepayment, repaymentDate);
        
        // Add the months difference to the loanTenure to get the total tenure for the Loan
        Decimal totalTenure = loanTenure + monthsDifference;
        
        return totalTenure;
    }
    
    // Method to calculate the difference in months between two dates
    private Integer calculateMonthsDifference(Date date1, Date date2) {
        Integer monthsDifference = 0;
        Date startDate = date1 < date2 ? date1 : date2;
        Date endDate = date1 < date2 ? date2 : date1;
        
        while (startDate.addMonths(monthsDifference) < endDate) {
            monthsDifference++;
        }
        
        // Check if the lastDateOfRepayment is before the repaymentDate
        // If yes, then the tenure will be negative, which is not allowed, so return 0 in that case
        if (date1 > date2) {
            return 0;
        }
        
        return monthsDifference;
    }
    
    // Method to send email notification
    private void sendEmailNotification(List<Loan__c> loansWithMismatch) {
        // Implement the logic to send emails here
        // You can use the Messaging.EmailFileAttachment and Messaging.SingleEmailMessage classes to create and send emails.
    }
}