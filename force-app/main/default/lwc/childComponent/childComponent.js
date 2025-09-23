import { LightningElement } from 'lwc';

export default class ChildComponent extends LightningElement {
    handleClick() {
        const event = new CustomEvent('myevent', {
            detail: { message: 'Hello from child!' }
        });
        this.dispatchEvent(event);
    }
}
