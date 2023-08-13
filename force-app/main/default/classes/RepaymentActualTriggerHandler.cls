public class RepaymentActualTriggerHandler {
    public static void handleAfterInsertUpdate(List<Repayment_Actual__c> raList) {
        Set<Id> rsList = new Set<Id>();
        List<Repayment_Schedule__c> repaymentScheduleListToUpdate = new List<Repayment_Schedule__c>();
        
        for (Repayment_Actual__c repaymentActual : raList) {
            if (repaymentActual.Actual_Repayment_Date__c > repaymentActual.Repayment_Schedule__r.Last_Date_of_Repayment__c) {
                rsList.add(repaymentActual.Repayment_Schedule__c);
            }
            
            /*if (repaymentActual.Amount_Deposited__c == 0) {
                repaymentActual.Late_fees_applicable__c = true;
            }*/
        }
        //update raList;
        
        if (!rsList.isEmpty()) {
            
            for (Id scheduleId : rsList) {
                repaymentScheduleListToUpdate.add(new Repayment_Schedule__c(
                    Id = scheduleId,
                    Missed__c = true
                ));
            }try{
            update repaymentScheduleListToUpdate;
            }catch (Exception e){
                System.debug('Error updating Repayment Schedule records: ' + e.getMessage());
            }
        }
    }
}