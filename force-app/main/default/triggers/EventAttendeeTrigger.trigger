trigger EventAttendeeTrigger on Event_Attendee__c (after insert) {

    /*if(Trigger.isAfter && Trigger.isInsert){
        EventAttendeeTriggerHandler.sendConfirmationEmail(Trigger.New);
    }*/
    System.debug('EventAttendeeTrigger running');
    new EventAttendeeTriggerHandler().run();
}