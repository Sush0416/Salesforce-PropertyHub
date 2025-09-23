import { LightningElement } from 'lwc';

export default class CleanPropertyList extends LightningElement {
    properties = [
        { Id: '1', Name: 'Greenwood Villa', Price__c: '750000', Status__c: 'Available' },
        { Id: '2', Name: 'Sunset Apartments', Price__c: '550000', Status__c: 'Available' },
        { Id: '3', Name: 'Grand Hotels & Resorts Ltd', Price__c: '3500000', Status__c: 'Available' },
        { Id: '4', Name: '3BHK Apartment Gurgaon', Price__c: '6500000', Status__c: 'Available' },
        { Id: '5', Name: 'Luxury Villa Delhi', Price__c: '8500000', Status__c: 'Available' }
    ];
}