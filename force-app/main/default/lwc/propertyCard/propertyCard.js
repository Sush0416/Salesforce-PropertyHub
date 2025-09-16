import { LightningElement, api } from 'lwc';

export default class PropertyCard extends LightningElement {
    @api property;
    
    get formattedPrice() {
        if (!this.property.Price__c) return '$0';
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
            minimumFractionDigits: 0
        }).format(this.property.Price__c);
    }
    
    get propertyImage() {
        // Placeholder image - in real implementation, use actual property images
        return 'https://via.placeholder.com/300x200/4CAF50/white?text=Property+Image';
    }
    
    handleCardClick() {
        const selectEvent = new CustomEvent('propertyselect', {
            detail: this.property.Id
        });
        this.dispatchEvent(selectEvent);
    }
}