public with sharing class EventDetailsController {
    @AuraEnabled(Cacheable=true)
    public static List<EventSpeakers__c> getSpeakers(String eventId){
        System.debug('Getting speaker details');
        List<EventSpeakers__c> eventSpeakers = [SELECT Id, Speaker__c, Speaker__r.Name, Speaker__r.Email__c, Speaker__r.Phone__c, Speaker__r.Company__c
            FROM EventSpeakers__c WHERE Event__c =:eventId];
        System.debug(eventSpeakers);
        return eventSpeakers;
    }
}
