public class EventSpeakersTriggerHandler extends TriggerHandler {
	List<EventSpeakers__c> EventSpeakers;
    
    public EventSpeakersTriggerHandler(){
        EventSpeakers = (List<EventSpeakers__c>)Trigger.New;
        System.debug('EventSpeakers: ' + EventSpeakers);
    }
    
    public override void beforeInsert() {
        System.debug('Event speaker beforeInsert running');
        this.rejectDuplicateBooking();
    }
    
    public override void beforeUpdate() {
        this.rejectDuplicateBooking();
    }
    
    private void rejectDuplicateBooking(){
        // step 1: Get speaker id & event id
        // ste2 2: SOQL on event to get start date and put them into map
        // Step 3: SOQL on event-speaker to get related speaker along with event start date
        // step 4: check condition and show error
        
        //step 1 - start
        Set<Id> speakerIdSet = new Set<Id>();
        Set<Id> eventIdSet = new Set<Id>();
        
        for (EventSpeakers__c es : this.EventSpeakers) {
            speakerIdSet.add(es.Speaker__c);
            eventIdSet.add(es.Event__c);
        }
        //step 1 - end
        
        // step 2 - start
        Map<Id, DateTime> requestesEvents = new Map<Id, DateTime>();
        List<Event__c> relatedEventList = [SELECT Id, Start_DateTime__c FROM Event__c WHERE Id IN :eventIdSet];
        for (Event__c relatedEvent : relatedEventList) {
            requestesEvents.put(relatedEvent.Id, relatedEvent.Start_DateTime__c);
        }
        // Step 2 - end
        
        // step 3 - start
        List<EventSpeakers__c> relatedEventSpeakers = [SELECT Id, Event__c, Speaker__c, Event__r.Start_DateTime__c
                                                     FROM EventSpeakers__c WHERE Speaker__c IN :speakerIdSet];
        // step 3 - end
        
        // step 4 - start
        for (EventSpeakers__c es : this.EventSpeakers) {
            DateTime bookingTime = requestesEvents.get(es.Event__c);
            for (EventSpeakers__c es1 : relatedEventSpeakers) {
                if (es.Speaker__c == es1.Speaker__c && es1.Event__r.Start_DateTime__c == bookingTime) {
                    es.Speaker__c.addError('The speaker is already booked at this time');
                }
            }
        }
        // step 4 - end
    }
    
}