import { LightningElement, api } from 'lwc';

export default class PropertyFilter extends LightningElement {
    searchKey = '';
    minPrice = '';
    maxPrice = '';
    minBedrooms = '';
    maxBedrooms = '';
    propertyType = '';
    city = '';

    propertyTypeOptions = [
        { label: 'All Types', value: '' },
        { label: 'Single Family', value: 'Single Family' },
        { label: 'Condo', value: 'Condo' },
        { label: 'Townhouse', value: 'Townhouse' },
        { label: 'Apartment', value: 'Apartment' }
    ];

    handleSearchChange(event) {
        this.searchKey = event.target.value;
    }

    handleMinPriceChange(event) {
        this.minPrice = event.target.value;
    }

    handleMaxPriceChange(event) {
        this.maxPrice = event.target.value;
    }

    handleMinBedroomsChange(event) {
        this.minBedrooms = event.target.value;
    }

    handleMaxBedroomsChange(event) {
        this.maxBedrooms = event.target.value;
    }

    handlePropertyTypeChange(event) {
        this.propertyType = event.detail.value;
    }

    handleCityChange(event) {
        this.city = event.target.value;
    }

    handleApplyFilters() {
        const filters = {
            searchKey: this.searchKey,
            minPrice: this.minPrice ? parseInt(this.minPrice) : null,
            maxPrice: this.maxPrice ? parseInt(this.maxPrice) : null,
            minBedrooms: this.minBedrooms ? parseInt(this.minBedrooms) : null,
            maxBedrooms: this.maxBedrooms ? parseInt(this.maxBedrooms) : null,
            propertyType: this.propertyType,
            city: this.city
        };

        this.dispatchEvent(new CustomEvent('filterchange', {
            detail: filters
        }));
    }

    handleClearFilters() {
        this.searchKey = '';
        this.minPrice = '';
        this.maxPrice = '';
        this.minBedrooms = '';
        this.maxBedrooms = '';
        this.propertyType = '';
        this.city = '';

        this.dispatchEvent(new CustomEvent('filterchange', {
            detail: {
                searchKey: '',
                minPrice: null,
                maxPrice: null,
                minBedrooms: null,
                maxBedrooms: null,
                propertyType: '',
                city: ''
            }
        }));
    }
}