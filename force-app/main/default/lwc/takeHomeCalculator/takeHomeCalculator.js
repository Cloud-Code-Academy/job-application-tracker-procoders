import { LightningElement, track } from 'lwc';

export default class TakeHomeCalculator extends LightningElement {
    @track annualSalary = 0;
    @track takeHomeSalary = 0; 

    handleSalaryChange(event) {
        this.annualSalary = event.target.value;
        this.takeHomeSalary = this.annualSalary * 0.70;
    }
    get formattedTakeHomeSalary() {
        return new Intl.NumberFormat('en-Us', {
            style: 'currency',
            currency: 'USD'
        }).format(this.takeHomeSalary);
    }
    get formattedMonthly() {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(this.takeHomeSalary / 12);
    }
    get formattedBiWeekly() {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(this.takeHomeSalary / 26);
}
get formattedWeekly() {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(this.takeHomeSalary / 52);
}
}