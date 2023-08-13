public with sharing class RepaymentActualImportController {
    @AuraEnabled
    public static String importRepaymentActualData(String csvData) {
        try {
            // Split the CSV data into lines
            List<String> csvLines = csvData.split('\n');
            
            // Initialize variables to store the results and error messages
            List<Repayment_Actual__c> repaymentActualList = new List<Repayment_Actual__c>();
            List<String> errorMessages = new List<String>();
            
            // Loop through each line of the CSV data starting from the second line (skip the header)
            for (Integer i = 1; i < csvLines.size(); i++) {
                String csvLine = csvLines[i];
                
                // Split each line into fields based on the CSV separator (comma)
                List<String> csvFields = csvLine.split(',');
                
                // Ensure the line has the expected number of fields (adjust based on your CSV structure)
                if (csvFields.size() != 3) {
                    errorMessages.add('Invalid CSV line at line ' + (i + 1) + ': Missing or extra fields.');
                    continue; // Skip this line and proceed to the next one
                }
                
                // Extract data from each field (adjust based on your CSV structure)
                String repaymentScheduleId = csvFields[0];
                Date actualRepaymentDate = Date.valueOf(csvFields[1]);
                Decimal depositAmount = Decimal.valueOf(csvFields[2]);
                
                // Create the Repayment Actual record
                Repayment_Actual__c repaymentActual = new Repayment_Actual__c(
                    Repayment_Schedule__c = repaymentScheduleId,
                    Actual_Repayment_Date__c = actualRepaymentDate,
                    Amount_Deposited__c = depositAmount
                );
                
                // Add the record to the list
                repaymentActualList.add(repaymentActual);
            }
            
            // Insert the Repayment Actual records
            insert repaymentActualList;
            
            return 'Import successful. ' + repaymentActualList.size() + ' records created.';
        } catch (Exception ex) {
            return 'Error occurred during import: ' + ex.getMessage();
        }
    }
}