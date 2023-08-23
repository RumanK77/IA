public with sharing class CreateRepaymentActualRecord { 
    
    @AuraEnabled
    public static List<Repayment_Actual__c> importCSVFile(String base64Data){//,Id cdbId){
        String data=JSON.deserializeUntyped(base64Data).toString();
        List<Repayment_Actual__c> ListRA = new List<Repayment_Actual__c>();  
        List<String> lstCSVLines = data.split('\n');
        
        for(Integer i = 1; i < lstCSVLines.size(); i++){
            Repayment_Actual__c RA = new Repayment_Actual__c();
            String csvLine = lstCSVLines[i];
            String prevLine = csvLine;
            Integer startIndex;
            Integer endIndex;
            
            while(csvLine.indexOf('"') > -1){
                if(startIndex == null){
                    startIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
                }else{
                    if(endIndex == null){
                        endIndex = csvLine.indexOf('"');
                        csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                    }
                }
                if(startIndex != null && endIndex != null){
                    String sub = csvLine.substring(startIndex, endIndex);
                    sub = sub.replaceAll(',', ':comma:');
                    csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                    startIndex = null;
                    endIndex = null;
                }
            }
            
            List<String> csvRowData = new List<String>();
            for(String column : csvLine.split(',')){
                column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',').trim();
                csvRowData.add(column);
            }
            RA.Actual_Repayment_Date__c = Date.parse(csvRowData[0]);//Date.valueOf(csvRowData[0]);
            RA.Amount_Deposited__c = Decimal.valueOf(csvRowData[1]);//csvRowData[1] != '':Decimal.valueOf(csvRowData[1]) ?;
            RA.Repayment_Schedule__c = csvRowData[2];
            ListRA.add(RA);
        }
        insert ListRA;
        return [Select Id, Actual_Repayment_Date__c, Amount_Deposited__c, Repayment_Schedule__c From Repayment_Actual__c];
    }  
}