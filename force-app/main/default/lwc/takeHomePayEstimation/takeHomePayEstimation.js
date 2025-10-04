import { LightningElement, api, wire, track } from "lwc";
import { getRecord } from 'lightning/uiRecordApi';

const SOCIAL_SECURITY = 0.062;       // Social Security tax rate (6.2%)
const MEDICARE = 0.0145;    // Medicare tax rate (1.45%)
const FEDERAL = 0.20; // Assumed Federal tax rate (20% flat)
const SALARY = ['Job_Application__c.Expected_Salary__c'];

export default class TakeHomePayEstimate extends LightningElement {
    // raw numeric values
    salary = 0;

    //Salary in different time periods
    yearlyPay = 0;
    sixMonthsPay = 0;
    monthlyPay = 0;
    biWeeklyPay = 0;

    // raw numeric tax values (numbers)
    yearlyFederalIncomeTax = 0;
    yearlySocialSecurityTax = 0;
    yearlyMedicareWithholding = 0;

    @api recordId;

    // wire to get the record
    @wire(getRecord, { recordId: '$recordId', fields: SALARY })
    wiredSalary({ data, error }) {
        if (data && data.fields && data.fields.Expected_Salary__c) {
            const value = data.fields.Expected_Salary__c.value;
            // ensure numeric
            this.salary = Number(value) || 0;
            this.detailedCalculation(this.salary);
        } else if (error) {
            // optionally set defaults or notify user
            this.resetValues();
            // console.error(error);
        }
    }

    detailedCalculation(payInput) {
    // ensure numeric
    const pay = Number(payInput) || 0;

    // calculate raw numeric taxes
    this.yearlyFederalIncomeTax = pay * FEDERAL;
    this.yearlySocialSecurityTax = pay * SOCIAL_SECURITY;
    this.yearlyMedicareWithholding = pay * MEDICARE;

    // total taxes
    const totalTaxes = this.yearlyFederalIncomeTax
                        + this.yearlySocialSecurityTax
                        + this.yearlyMedicareWithholding;

    // net yearly pay numeric
    this.yearlyPay = pay - totalTaxes;

    // prevent negative weirdness
    if (!isFinite(this.yearlyPay) || isNaN(this.yearlyPay)) {
        this.yearlyPay = 0;
    }

    // derive other periods (numeric)
    this.sixMonthsPay = this.yearlyPay / 2;
    this.monthlyPay = this.yearlyPay / 12;
    this.biWeeklyPay = this.yearlyPay / 26;
    }

    resetValues() {
    this.salary = 0;
    this.yearlyPay = 0;
    this.sixMonthsPay = 0;
    this.monthlyPay = 0;
    this.biWeeklyPay = 0;
    this.yearlyFederalIncomeTax = 0;
    this.yearlySocialSecurityTax = 0;
    this.yearlyMedicareWithholding = 0;
    }
    
    calculatePay(event) {
        const raw = event.target.value;
        const num = Number(raw);

        if (raw.trim() === '' || isNaN(num)) {
            this.resetValues();
            return;
        }

        this.salary = num;
        this.detailedCalculation(num);
    }

    // create display getters for formatted strings:
    get yearlyPayDisplay() {
        return this.yearlyPay.toFixed(2);
    }
    get monthlyPayDisplay() {
        return this.monthlyPay.toFixed(2);
    }
    get sixMonthsPayDisplay() {
        return this.sixMonthsPay.toFixed(2);
    }
    get biWeeklyPayDisplay() {
        return this.biWeeklyPay.toFixed(2);
    }
    get yearlyFederalIncomeTaxDisplay() {
        return this.yearlyFederalIncomeTax.toFixed(2);
    }
    get yearlySocialSecurityTaxDisplay() {
        return this.yearlySocialSecurityTax.toFixed(2);
    }
    get yearlyMedicareWithholdingDisplay() {
        return this.yearlyMedicareWithholding.toFixed(2);
    }

}

//weirdsourcer