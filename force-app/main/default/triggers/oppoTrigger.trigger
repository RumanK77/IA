trigger oppoTrigger on Opportunity (after update) {
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            OppoTriggerHandler.createNewLoanRecord(Trigger.new, Trigger.oldMap);
        }
    }
}



//oppoTrigger
//OppoTriggerHandler
//OppoTriggerHandlerTest
//DeleteHistoricalLoanRecordsBatch
//BatchTimer
//checkTenure
//CreateRepaymentActualRecord