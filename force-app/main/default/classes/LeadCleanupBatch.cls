public class LeadCleanupBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Status, CreatedDate 
            FROM Lead 
            WHERE Status = 'Open' 
            AND CreatedDate < LAST_N_DAYS:30
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();
        for(Lead l : scope){
            l.Status = 'Expired';
            leadsToUpdate.add(l);
        }
        if(!leadsToUpdate.isEmpty()){
            update leadsToUpdate;
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        // Optional: Send email notification or post-processing
        System.debug('Batch processing completed successfully!');
    }
}