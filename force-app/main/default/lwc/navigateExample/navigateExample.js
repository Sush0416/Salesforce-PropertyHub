import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NavigateExample extends NavigationMixin(LightningElement) {

    navigateToRecordPage() {
        // Navigate to a specific record page (replace recordId with an actual Id)
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: '001XXXXXXXXXXXXXXX', // Replace with a real record Id
                objectApiName: 'Account',      // Object API name
                actionName: 'view'             // Action: view / edit / clone
            }
        });
    }

    navigateToURL() {
        // Navigate to an external URL
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://www.salesforce.com'
            }
        });
    }
}
