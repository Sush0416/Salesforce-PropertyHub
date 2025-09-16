({
    doInit: function(component, event, helper) {
        helper.loadProperties(component);
    },
    
    handleFilterChange: function(component, event, helper) {
        const filters = event.getParam('detail');
        component.set('v.filters', filters);
        helper.loadProperties(component);
    },
    
    handlePropertySelect: function(component, event, helper) {
        const propertyId = event.getParam('detail');
        const navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            "recordId": propertyId,
            "slideIn": true
        });
        navEvent.fire();
    }
})