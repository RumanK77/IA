trigger RepaymentActualTrigger on Repayment_Actual__c (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        RepaymentActualTriggerHandler.handleAfterInsertUpdate(Trigger.new);
    }
}