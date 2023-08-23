trigger RepaymentScheduleTrigger on Repayment_Schedule__c (before insert, before update, before delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            RepaymentScheduleTriggerHandler.checkRepaymentDateMonth(Trigger.new);
        }
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete){
            SumOfRepaymentAmount.validateTotalRepaymentAmount(Trigger.new, Trigger.old, Trigger.operationType);
        }
    }
}