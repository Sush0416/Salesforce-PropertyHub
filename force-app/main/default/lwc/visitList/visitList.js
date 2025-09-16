import { LightningElement, api } from 'lwc';

export default class VisitList extends LightningElement {
    @api visits;
    
    get hasVisits() {
        return this.visits && this.visits.length > 0;
    }
    
    get formattedVisits() {
        if (!this.visits) return [];
        
        return this.visits.map(visit => ({
            ...visit,
            formattedDateTime: this.formatDateTime(visit.Visit_DateTime__c),
            leadName: visit.Lead__r ? visit.Lead__r.Name : 'N/A',
            leadEmail: visit.Lead__r ? visit.Lead__r.Email : 'N/A',
            leadPhone: visit.Lead__r ? visit.Lead__r.Phone : 'N/A'
        }));
    }
    
    formatDateTime(dateTime) {
        if (!dateTime) return 'N/A';
        
        return new Date(dateTime).toLocaleString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }
}