import { LightningElement , track} from 'lwc';

export default class FetchEmployee extends LightningElement {
    @track employeeData = [];
    error;

    handleClick() {
        fetch('https://dummy.restapiexample.com/api/v1/employees')
        .then((response) => {
            if(!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then((data) => {
        this.employeesData = data.data;
        this.error = undefined;
    })
    .catch((error) => {
        this.error = error.message;
        this.employeeData = [];
        });
    }
}