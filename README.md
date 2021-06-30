# Salesforce-Project

This project helps an event management company to manage their events very effectively along with the attends and location information. 

We need following custom objects:

1. Location:
   1. Street (Text)
   2. City (Text)
   3. State (Text)
   4. Postal code (Text) 
   5. Country (Picklist)
   6. Landmark (Text)
   7. Verified (Checkbox)

2. Event Organizer
   1. Name (Standard field)
   2. Email (Email)
   3. Alternative Email (Email)
   4. Phone (Phone)
   5. Alternative Phone (Phone)
   6. Address (Lookup -Location)
   
3. Event
   1. Event # (Standard Auto Number)
   2. Name (text)
   3. Status (Picklist - Created/Published/In Progress/Completed.Postponed/Cancelled)
   4. Organizer (Lookup- Event organizer)
   5. Start Date (Date)
   6. End Date (date)
   7. Max Seat (Number)
   8. # People Attending (Rollup summary field)
   9. Remaining Seats (Formula field - Max Seats - # People attending)
   10. Lookup (Location)
   11. Location verified (Formula Location__r.Verified__c)
   12. Live? (Checkbox)
   13. Recurring? (Checkbox)
   14. Event Type (Picklist - In-person/Virtual)
   15. Frequency (Picklist - Daily/Weekly)
   
4. Attendees
   1. Name (Standard)
   2. Email (Email)
   3. Phone (Phone)
   4. Company Name (text)
   5. Address (Lookup)

5. Speaker
   1. Name (Text)
   2. Email (Email)
   3. Phone (Phone)
   4. Company (Text)

6. Event-Attendee
   1. Eveent (M.D. Event)
   2. Attendee (M.D. Attendee)

7. Event-Speaker
   1. Event (M.D. Event)
   2. Speaker (M.D. Speaker)

8. Error-log
   1. Log Date/Title (Store Date and Time when error occured)
   2. Log Details (Text Area long)
   3. Process Name (text)
   4. Log # (Auto Generated Number)
