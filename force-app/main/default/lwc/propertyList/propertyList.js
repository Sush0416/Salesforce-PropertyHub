import { LightningElement } from 'lwc';

export default class PropertyList extends LightningElement {
    properties = [
        {
            id: '1',
            name: 'Luxury Villa in Mumbai',
            price: '2,50,00,000',
            status: 'Available',
            type: 'Villa'
        },
        {
            id: '2', 
            name: '2BHK Apartment in Pune',
            price: '85,00,000',
            status: 'Available',
            type: 'Apartment'
        }
    ];

    handleViewDetails(event) {
        const propertyId = event.target.dataset.id;
        console.log('View details for property ID:', propertyId);
        
        // ✅ YEH NAYA LINE ADD KARO:
        console.log('EVENT TRIGGERED: Property selected with ID', propertyId);
        
        alert('Showing details for property: ' + propertyId);
    }
}