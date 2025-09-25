import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    handleChildEvent(event) {
        console.log('Event received:', event.detail.message);
        alert('Event received: ' + event.detail.message);
    }
}