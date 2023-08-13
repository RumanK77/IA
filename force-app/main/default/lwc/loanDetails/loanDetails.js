import { LightningElement } from 'lwc';
import Loan from '@salesforce/apex/DemoLoanClass.getdata';
export default class LoanDetails extends LightningElement {
    searchResult;
    handleSearch({ }){
        Loan()
        .then(result =>{
            console.log('result is ', result);
        this.searchResult =result;
        })
        .catch(error => {
            console.log('error happened ', error);
        });
    }
}