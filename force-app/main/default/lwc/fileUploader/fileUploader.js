import { LightningElement, track, api } from 'lwc';
import importCSVFile from '@salesforce/apex/CreateRepaymentActualRecord.importCSVFile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Actual_Repayment_Date__c', fieldName: 'Actual_Repayment_Date__c' },
    { label: 'Amount_Deposited__c', fieldName: 'Amount_Deposited__c' },
    { label: 'Repayment_Schedule__c', fieldName: 'Repayment_Schedule__c' }
];

export default class fileUploader extends LightningElement {
    @api recordid;
    @track columns = columns;
    @track data;
    @track fileName = '';
    @track UploadFile = 'Upload CSV File';
    @track showLoadingSpinner = false;
    @track isTrue = false;
    @track showError = false;

    selectedRecords;
    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 1500000;

    handleFilesChange(event) {
        console.log('file change event' + JSON.stringify(event) + ' length ' + event.target.files.length);
        if (event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = event.target.files[0].name;
        }
    }

    handleSave() {
        if (this.filesUploaded.length > 0) {
            console.log('Inside handle save'+this.filesUploaded.length)
            this.uploadHelper();
        }
        else {
            this.fileName = 'Please select a CSV file to upload!!';
        }
    }

    uploadHelper() {
        this.file = this.filesUploaded[0];
        console.log('uploadHelper'+this.file)
        if (this.file.size > this.MAX_FILE_SIZE) {
            window.console.log('File Size is to long');
            return;
        }
        this.showLoadingSpinner = true;
        this.fileReader = new FileReader();
        this.fileReader.onloadend = (() => {
            console.log('inside fileReadert')
            this.fileContents = this.fileReader.result;
            this.saveToFile();
        });
        this.fileReader.readAsText(this.file);
    }

    /*validateAndSaveToFile() {
        const lines = this.fileContents.split('\n');
        for (let i = 1; i < lines.length; i++) {
            const csvRowData = lines[i].split(',');
            const repaymentSchedule = csvRowData[2];
            if (!repaymentSchedule) {
                this.showError = true;
                this.showLoadingSpinner = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Repayment Schedule is missing for some rows in the CSV file',
                        variant: 'error',
                    })
                );
                return;
            }
        }
        this.showError = false;
        this.saveToFile();
    }*/

    saveToFile() {
        console.log('saveToFile')
        importCSVFile({ base64Data: JSON.stringify(this.fileContents), cdbId: this.recordid })
            .then(result => {
                window.console.log('result ====> ');
                window.console.log(result);
                this.data = result;
                this.fileName = this.fileName + ' - Uploaded Successfully';
                this.isTrue = false;
                this.showLoadingSpinner = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!!',
                        message: this.file.name + ' - Uploaded Successfully!!!',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                window.console.log(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while uploading File',
                        message: error.message,
                        variant: 'error',
                    }),
                );
            });
    }
}