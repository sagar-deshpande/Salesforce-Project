public class EventAttendeeTriggerHandler extends TriggerHandler {
    
    List<Event_Attendee__c> newRecordList;
    
    public EventAttendeeTriggerHandler(){
        System.debug('EventAttendeeTriggerHandler constructor running');
        newRecordList = (List<Event_Attendee__c>)Trigger.New;
    }
    
    public override void afterInsert(){
        System.debug('EventAttendeeTriggerHandler.afterInsert running');
        this.sendConfirmationEmail();
    }
    
    private void sendConfirmationEmail( ) {
        Set<Id> Attendees = new Set<Id>();
        Set<Id> Events = new Set<Id>();
        
        for (Event_Attendee__c ea : this.newRecordList) {
            Attendees.add(ea.Attendee__c);
            Events.add(ea.Event__c);
        }
        
        Map<Id, Attendee__c> attendeeMap = new Map<Id, Attendee__c>(
            [SELECT Id, Name, Email__c FROM Attendee__c WHERE Id IN :Attendees]
            );
        Map<Id, Event__c> eventMap = new Map<Id, Event__c>(
            						[SELECT Id, Name__c, Start_DateTime__c, Location__c, 
                                    Location__r.Name, Location__r.Street__c, Location__r.Land_Mark__c, Location__r.City__c,
                                    Location__r.State__c, Location__r.Country__c, Location__r.Postal_Code__c,
                                    Event_Organizer__r.Name FROM Event__c WHERE Id IN :Events]
            );
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for (Event_Attendee__c ea : this.newRecordList) {
            Attendee__c att = attendeeMap.get(ea.Attendee__c);
            String attendeeName = att.Name;
            String attendeeEmail = att.Email__c;
            Event__c eve = eventMap.get(ea.Event__c);
            String eventName = eve.Name__c;
            DateTime eventDateTime = eve.Start_DateTime__c;
            String eventLocation = eve.Location__r.Name +', ' + eve.Location__r.Street__c + ', ' + eve.Location__r.Land_Mark__c +
                				   eve.Location__r.City__c + ', ' + eve.Location__r.State__c + ', ' + eve.Location__r.Country__c + 
                				   ', ' + eve.Location__r.Postal_Code__c;
            String eventOrganizer = eve.Event_Organizer__r.Name;
            
            /* Prepare Email Template */
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Pass for ' + eventName);
            String hrefForLocation = '<a href="https://www.google.com/maps/place/'+eventLocation+'" '+'target="_blank">Here</a>';
            mail.setHtmlBody('Dear '+attendeeName + ',<br/>'+ 'Thank you for registering for ' +eventName+ ' which will be organized on'+
                            string.valueOf(eventDateTime)+ ' & will be held in ' + eventLocation +'. We are excited to have you, see you in event.' +
                            'Find the google map location ' + hrefForLocation +'.'+
                            '<br/> Thanks, <br/>' + eventOrganizer);
            List<String> attendeeEmailList = new List<String>();
            attendeeEmailList.add(attendeeEmail);
            mail.setToAddresses(attendeeEmailList);
            mail.setSenderDisplayName(eventOrganizer);
            emailList.add(mail);
        }
        if (emailList.size()>0){
            try{
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailList, false);
                for (Messaging.SendEmailResult result : results) {
                    if(!result.isSuccess()){
                        System.debug('Email sending failed. Logging with error');
                        TransactionLogHandler.doHandleExceptionWithError(JSON.serialize(result.getErrors()), 'EventAttendeeTriggerHandler.sendConfirmationEmail');
                    }
                    else {
                        System.debug('Email sent');
                    }
                }
            }catch(System.Exception ex) {
                System.debug('Email sending failed. Logging with exception');
                TransactionLogHandler.doHandleException(ex, 'EventAttendeeTriggerHandler.sendConfirmationEmail');
            }
        }
    }
}