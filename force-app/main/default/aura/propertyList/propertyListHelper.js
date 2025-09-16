({
    loadProperties: function(component) {
        component.set('v.loading', true);
        component.set('v.error', '');
        
        const filters = component.get('v.filters');
        
        const action = component.get('c.getProperties');
        action.setParams({
            searchKey: filters.searchKey || '',
            minPrice: filters.minPrice,
            maxPrice: filters.maxPrice,
            minBedrooms: filters.minBedrooms,
            maxBedrooms: filters.maxBedrooms,
            propertyType: filters.propertyType || '',
            city: filters.city || ''
        });
        
        action.setCallback(this, function(response) {
            component.set('v.loading', false);
            const state = response.getState();
            
            if (state === 'SUCCESS') {
                component.set('v.properties', response.getReturnValue());
            } else if (state === 'ERROR') {
                const errors = response.getError();
                let errorMessage = 'Unknown error';
                if (errors && errors[0] && errors[0].message) {
                    errorMessage = errors[0].message;
                }
                component.set('v.error', errorMessage);
            }
        });
        
        $A.enqueueAction(action);
    }
})