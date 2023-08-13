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




/*list<Id> failedRecordIds = new List<Id>();
public Database.QueryLocator start(Database.BatchableContext context){
//Date oneMonthAgo = Date.today().addMonths(-1);
Date threeDaysAgo = Date.today().addDays(-3);
string query = 'select Id From Loan__c where CreatedDate < : threeDaysAgo';
return Database.getQueryLocator(query);
}

public void execute(Database.BatchableContext context, list<Loan__c> checkList){
//list<Loan__c> loansToDelete = (List<Loan__c>) checkList;
//delete loansToDelete;
try{
delete checkList;
}catch(Exception e){
for(Loan__c record : checkList){
failedRecordIds.add(record.Id);
}
}
} 

public void finish (Database.BatchableContext context){
if(!failedRecordIds.isEmpty()){
sendEmail(failedRecordIds);
}
}

private void sendEmail(list<Id> failedIds){
String emailBody = 'Fail To Delete Loan Records: ' + String.join(failedIds, ', ');
Messaging.singleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {'rumankadri77@gmail.com'});
mail.setSubject('Failed Loan Deletion');
mail.setPlainTextBody(emailBody);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
} */