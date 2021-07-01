trigger LocationTrigger on Location__c (before insert, before update, before delete,
                                        after insert, after update, after delete, after undelete) {
    /*
    if(Trigger.isAfter && Trigger.isInsert ){
        for( Location__c loc : Trigger.New ){
            LocationTriggerHandler.verifyAddress(loc.Id); 
        }
    }
    */
    
    System.debug('LocationTrigger running');
    new LocationTriggerHandler().run();
}