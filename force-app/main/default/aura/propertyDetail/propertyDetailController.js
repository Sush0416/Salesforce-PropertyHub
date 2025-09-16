({
    doInit: function(component, event, helper) {
        helper.loadPropertyDetails(component);
    },
    
    recordIdChanged: function(component, event, helper) {
        helper.loadPropertyDetails(component);
    },
    
    handleEdit: function(component, event, helper) {
        const editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        editRecordEvent.fire();
    }
})