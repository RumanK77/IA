import { LightningElement, api } from 'lwc';

export default class LoanPathAssistant extends LightningElement {
    @api recordId;
    currentStep = "New";
}