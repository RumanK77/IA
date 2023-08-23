global class DeleteHistoricalLoanRecordsBatch implements Database.Batchable<SObject>, Database.Stateful{
    String strObjectName;
    Date fourDaysAgo = Date.today().addDays(-4);
    list<Id> undeletedRecordIds = new list<Id>();
    
    global DeleteHistoricalLoanRecordsBatch(String strObjectName){
        this.strObjectName = strObjectName;
    }
    
    global Database.QueryLocator start(Database.BatchableContext context){
        String SOQL = 'select Id from ' + strObjectName + ' where CreatedDate < : fourDaysAgo';
        return Database.getQueryLocator(SOQL);
    }
    
    global void execute(Database.BatchableContext context, list<sObject> checkList){
        try{
            delete checkList;
        }catch(Exception e){
            for(SObject record : checkList){
                undeletedRecordIds.add(record.Id);
            }
        }
    }
    
    global void finish (Database.BatchableContext context){
        if(!undeletedRecordIds.isEmpty()){
            String emailBody = 'undeleted Loan Records: ' + String.join(undeletedRecordIds, ', ');
            Messaging.singleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {'rumankadri77@gmail.com'});
            mail.setSubject('Undeleted Records');
            mail.setPlainTextBody(emailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
    }
}