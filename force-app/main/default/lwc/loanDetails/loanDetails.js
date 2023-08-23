import { LightningElement } from 'lwc';
import getData from '@salesforce/apex/DemoLoanClass.getdata';

export default class LoanDetails extends LightningElement {
    searchResult;

    handleSearch() {
        getData()
            .then(result => {
                console.log('result is ', result);
                this.searchResult = result;
            })
            .catch(error => {
                console.log('error happened ', error);
            });
    }
}
