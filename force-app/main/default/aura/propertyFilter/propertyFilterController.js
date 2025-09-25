({
    handleFilterChange: function(component, event) {
        var filters = component.get("v.filters");
        var source = event.getSource();
        var fieldName = source.get("v.aura:id");
        var value = source.get("v.value");
        
        filters[fieldName] = value;
        component.set("v.filters", filters);
    },
    
    applyFilters: function(component) {
        var filters = component.get("v.filters");
        var filterChangeEvent = component.getEvent("filterChange");
        filterChangeEvent.setParams({ "filters": filters });
        filterChangeEvent.fire();
    },
    
    clearFilters: function(component) {
        var filterChangeEvent;
        component.set("v.filters", {});
        filterChangeEvent = component.getEvent("filterChange");
        filterChangeEvent.setParams({ "filters": {} });
        filterChangeEvent.fire();
    }
})
