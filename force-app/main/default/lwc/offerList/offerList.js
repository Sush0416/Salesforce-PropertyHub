import { LightningElement, api } from 'lwc';

export default class OfferList extends LightningElement {
    @api offers;
    
    get hasOffers() {
        return this.offers && this.offers.length > 0;
    }
    
    get formattedOffers() {
        if (!this.offers) return [];
        
        return this.offers.map(offer => ({
            ...offer,
            formattedAmount: this.formatCurrency(offer.Offer_Amount__c),
            formattedDate: this.formatDate(offer.Offer_Date__c),
            opportunityName: offer.Opportunity__r ? offer.Opportunity__r.Name : 'N/A',
            stageName: offer.Opportunity__r ? offer.Opportunity__r.StageName : 'N/A'
        }));
    }
    
    formatCurrency(amount) {
        if (!amount) return '$0';
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
            minimumFractionDigits: 0
        }).format(amount);
    }
    
    formatDate(date) {
        if (!date) return 'N/A';
        return new Date(date).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        });
    }
}