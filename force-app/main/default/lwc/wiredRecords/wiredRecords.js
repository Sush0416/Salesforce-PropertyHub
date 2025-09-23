// Check if your JavaScript is properly wired to get data
import { LightningElement, wire } from 'lwc';
import getProperties from '@salesforce/apex/PropertyController.getProperties';

export default class WiredRecords extends LightningElement {
    @wire(getProperties) properties;
    error;
}