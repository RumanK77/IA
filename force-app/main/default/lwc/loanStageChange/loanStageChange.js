import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';

import LOAN_OBJECT from '@salesforce/schema/Loan__c';
import STAGE_FIELD from '@salesforce/schema/Loan__c.Loan_Stage__c';

export default class LoanStageChange extends LightningElement {
    @api recordId;

    selectedStage = '';
    stageOptions = [
        { label: 'New', value: 'New' },
        { label: 'In Discussion', value: 'In Discussion' },
        { label: 'Submitted for Approval', value: 'Submitted for Approval' },
        { label: 'Approved', value: 'Approved' },
        { label: 'Disbursed', value: 'Disbursed' },
        { label: 'Closed', value: 'Closed' }
    ];

    handleStageChange(event) {
        this.selectedStage = event.detail.value;
    }

    handleChangeStage() {
        const fields = {};
        fields[STAGE_FIELD.fieldApiName] = this.selectedStage;
        fields["Id"] = this.recordId;
        const recordInput = { fields };
        try {
            updateRecord(recordInput);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Loan Stage updated successfully',
                    variant: 'success'
                })
            );
            this.dispatchEvent(new CustomEvent('loanstagechanged'));
        } catch (error) {
            console.log('error' + error)
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error updating Loan Stage',
                    variant: 'error'
                })
            );
        }
    }
}