public virtual class TriggerHandler {
	private TriggerContext context;
    
    public TriggerHandler(){
        System.debug('TriggerHandler constructor running');
        this.setTriggerContext();
    }
    
    public void run() {
        System.debug('TriggerHandler.run is running');
        if (this.context == TriggerContext.BEFORE_INSERT){
            this.beforeInsert();
        }
        else if (this.context == TriggerContext.BEFORE_UPDATE){
            this.beforeUpdate();
        }
        else if (this.context == TriggerContext.BEFORE_DELETE){
            this.beforeDelete();
        }
        else if (this.context == TriggerContext.AFTER_INSERT){
            this.afterInsert();
        }
        else if (this.context == TriggerContext.AFTER_UPDATE){
            this.afterUpdate();
        }
        else if (this.context == TriggerContext.AFTER_DELETE){
            this.afterDelete();
        }
        else if (this.context == TriggerContext.AFTER_UNDELETE){
            this.afterUndelete();
        }
    }
    
    protected virtual void beforeInsert() {
        
    }
    protected virtual void beforeUpdate() {
        
    }
    protected virtual void beforeDelete() {
        
    }
    protected virtual void afterInsert() {
        
    }
    protected virtual void afterUpdate() {
        
    }
    protected virtual void afterDelete() {
        
    }
    protected virtual void afterUndelete() {
        
    }
    
    private Enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE, AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE, AFTER_UNDELETE
    }
    
    private void setTriggerContext(){
        if (Trigger.isExecuting) {
            if (Trigger.isBefore) {
                if (Trigger.isInsert){
                    this.context = TriggerContext.BEFORE_INSERT;
                }
                else if (Trigger.isUpdate){
                    this.context = TriggerContext.BEFORE_UPDATE;
                }
                else if (Trigger.isDelete) {
                    this.context = TriggerContext.BEFORE_DELETE;
                }
            }
            else if (Trigger.isAfter) {
                if (Trigger.isInsert){
                    this.context = TriggerContext.AFTER_INSERT;
                }
                else if (Trigger.isUpdate){
                    this.context = TriggerContext.AFTER_UPDATE;
                }
                else if (Trigger.isDelete) {
                    this.context = TriggerContext.AFTER_DELETE;
                }
                else if (Trigger.isUndelete) {
                    this.context = TriggerContext.AFTER_UNDELETE;
                }
            }
        }
    }
}