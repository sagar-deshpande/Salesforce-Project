trigger EventSpeakersTrigger on EventSpeakers__c (before insert, before update, before delete, after insert, after update,
                                                 after delete, after undelete) {
	System.debug('EventSpeakerTrigger is running');
    new EventSpeakersTriggerHandler().run();
}