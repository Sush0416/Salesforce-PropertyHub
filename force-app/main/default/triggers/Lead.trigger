trigger Lead on Lead (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        LeadTriggerHandler.afterInsert(Trigger.new);
    }
}