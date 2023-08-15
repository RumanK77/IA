trigger CreateRepaymentSchedules on Loan__c (before insert, before update) {
   /* List<Loan__c> loansToUpdate = new List<Loan__c>();
    List<Repayment_Schedule__c> schedulesToDelete = new List<Repayment_Schedule__c>();
    List<Repayment_Schedule__c> schedulesToInsert = new List<Repayment_Schedule__c>();
    
    for (Loan__c loan : Trigger.new) {
        Loan__c oldLoan = Trigger.oldMap.get(loan.Id);
        if (oldLoan == null || loan.Tenure__c != oldLoan.Tenure__c) {
            List<Repayment_Schedule__c> existingSchedules = [SELECT Id FROM Repayment_Schedule__c WHERE Loan__c = :loan.Id];
            
            Integer requiredSchedules = loan.Tenure__c;
            if (existingSchedules.size() > requiredSchedules) {
                //for(Integer i=requiredSchedules; i<existingSchedules.size(); i++){
                   // schedulesToDelete.add(existingSchedules[i]);
                //}
                schedulesToDelete.addAll(existingSchedules.subList(requiredSchedules, existingSchedules.size()));
            }
            else if (existingSchedules.size() < requiredSchedules) {
                for (Integer i = existingSchedules.size(); i < requiredSchedules; i++) {
                    schedulesToInsert.add(new Repayment_Schedule__c(
                        Loan__c = loan.Id
                    ));
                }
            }
        }
    }
    if (!schedulesToDelete.isEmpty()) {
        delete schedulesToDelete;
    }
    if (!schedulesToInsert.isEmpty()) {
        insert schedulesToInsert;
    }*/
}