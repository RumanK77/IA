trigger CaseTrigger on Case (after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete)){
        CaseTriggerHandler.NumberOfRelatedCases(trigger.new, null);
    }
    else if(Trigger.isAfter && Trigger.isUpdate){
        CaseTriggerHandler.NumberOfRelatedCases(Trigger.new, Trigger.oldMap);
    }
    else if(Trigger.isAfter && Trigger.isDelete){
        CaseTriggerHandler.NumberOfRelatedCases(trigger.new, null);
    }
}