import { LightningElement, api } from 'lwc';

export default class PropertyCard extends LightningElement {
    // Public properties that can be set from App Builder
    @api propertyName = 'Luxury Villa';
    @api propertyPrice = '2,50,00,000';
    @api propertyStatus = 'Available';
    @api propertyLocation = 'Mumbai, India';
    @api propertyType = 'Villa';

    handleScheduleVisit() {
        console.log('Schedule visit button clicked for: ', this.propertyName);
        
        // Show confirmation message
        this.dispatchEvent(new CustomEvent('schedulevisit', {
            detail: {
                propertyName: this.propertyName,
                propertyId: 'sample-id-123'
            },
            bubbles: true
        }));
        
        // Optional: Show alert to user
        alert(`Visit scheduled for ${this.propertyName}! Our agent will contact you shortly.`);
    }

    handleContactAgent() {
        console.log('Contact agent button clicked for: ', this.propertyName);
        
        this.dispatchEvent(new CustomEvent('contactagent', {
            detail: {
                propertyName: this.propertyName,
                message: 'I am interested in this property'
            },
            bubbles: true
        }));
        
        alert(`Agent will contact you about ${this.propertyName} within 24 hours.`);
    }
}