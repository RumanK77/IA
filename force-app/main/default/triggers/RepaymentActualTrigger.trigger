trigger RepaymentActualTrigger on Repayment_Actual__c (after insert, after update, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete){
            TotalRepaidAmountHandler.calculateTotalRepaidAmount(Trigger.new, Trigger.old, Trigger.isDelete);
        }
        
        if(Trigger.isInsert || Trigger.isUpdate){
            MissedCheckboxHandler.updateMissedCheckbox(Trigger.new);
        }
    }
}