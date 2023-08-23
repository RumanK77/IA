public class MissedCheckboxHandler {
    public static void updateMissedCheckbox(list<Repayment_Actual__c> newRepayments){
        try{
            set<Id> repaymentScheduleIds = new set<Id>();
            for (Repayment_Actual__c repaymentActual : newRepayments) {
                repaymentScheduleIds.add(repaymentActual.Repayment_Schedule__c);
            }
            List<Repayment_Schedule__c> schedulesToUpdate = [SELECT Id, Last_Date_Of_Repayment__c
                                                             FROM Repayment_Schedule__c
                                                             WHERE Id IN :repaymentScheduleIds
                                                            ];
            
            List<Repayment_Schedule__c> updates = new List<Repayment_Schedule__c>();
            
            for (Repayment_Schedule__c schedule : schedulesToUpdate) {
                Repayment_Actual__c relatedRepayment = [SELECT Actual_Repayment_Date__c
                                                        FROM Repayment_Actual__c
                                                        WHERE Repayment_Schedule__c = :schedule.Id
                                                        ORDER BY Actual_Repayment_Date__c DESC
                                                        LIMIT 1];
                
                if (relatedRepayment != null &&
                    schedule.Last_Date_Of_Repayment__c < relatedRepayment.Actual_Repayment_Date__c) {
                        schedule.Missed__c = true;
                        updates.add(schedule);
                    }
            }
            if (!updates.isEmpty()) {
                update updates;
            }
        }catch(Exception e){
            System.debug('An error occured: ' + e.getMessage());
        }
    }
}