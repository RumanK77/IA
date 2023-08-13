public with sharing class ImportRepaymentActualsController {/*
    @AuraEnabled
    public static String importCSVFile(String csvData) {
        try {
            List<Repayment_Actual__c> recordsToInsert = new List<Repayment_Actual__c>();
            List<String> csvRows = csvData.split('\n');
            Integer startIndex = 0;
            if (!csvRows.isEmpty() && csvRows[0].startsWith('Actual_Repayment_Date__c,Amount_Deposited__c,Repayment_Schedule__c')) {
                startIndex = 1;
            }
            for (Integer i = startIndex; i < csvRows.size(); i++) {
                String csvRow = csvRows[i];
                List<String> csvValues = csvRow.split(',');
                Repayment_Actual__c repaymentActual = new Repayment_Actual__c();
                repaymentActual.Repayment_Schedule__c = Id.valueOf(csvValues[0]);
                repaymentActual.Actual_Repayment_Date__c = Date.valueOf(csvValues[1]); 
                repaymentActual.Amount_Deposited__c= Decimal.valueOf(csvValues[2]); 
                recordsToInsert.add(repaymentActual); 
            } 
            if (!recordsToInsert.isEmpty()) {
                insert recordsToInsert;
            }
            return 'success';
        } catch (Exception ex) {
            return 'error: ' + ex.getMessage();
        }
    }*/
}