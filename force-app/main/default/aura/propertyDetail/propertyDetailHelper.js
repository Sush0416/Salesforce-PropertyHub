({
    loadPropertyDetails: function(component) {
        const recordId = component.get("v.recordId");
        if (!recordId) return;
        
        component.set('v.loading', true);
        component.set('v.error', '');
        
        const action = component.get('c.getPropertyDetails');
        action.setParams({
            propertyId: recordId
        });
        
        action.setCallback(this, function(response) {
            component.set('v.loading', false);
            const state = response.getState();
            
            if (state === 'SUCCESS') {
                const result = response.getReturnValue();
                component.set('v.property', result.property);
                component.set('v.visits', result.visits);
                component.set('v.offers', result.offers);
            } else if (state === 'ERROR') {
                const errors = response.getError();
                let errorMessage = 'Error loading property details';
                if (errors && errors[0] && errors[0].message) {
                    errorMessage = errors[0].message;
                }
                component.set('v.error', errorMessage);
            }
        });
        
        $A.enqueueAction(action);
    }
})