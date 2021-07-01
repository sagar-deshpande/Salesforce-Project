import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import EVENT_OBJECT from '@salesforce/schema/Event__c';
import NAME_FIELD from '@salesforce/schema/Event__c.Name__c';
import ORGANIZER_FIELD from '@salesforce/schema/Event__c.Event_Organizer__c';
import START_DATE_FIELD from '@salesforce/schema/Event__c.Start_DateTime__c';
import END_DATE_FIELD from '@salesforce/schema/Event__c.End_Date_Time__c';
import MAX_ATTENDEE_FIELD from '@salesforce/schema/Event__c.Max_Seats__c';
import LOCATION_FIELD from '@salesforce/schema/Event__c.Location__c';
import DETAILS_FIELD from '@salesforce/schema/Event__c.Event_Detail__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation'
//const FIELDS = [NAME_FIELD, ORGANIZER_FIELD, START_DATE_FIELD, END_DATE_FIELD, MAX_ATTENDEE_FIELD, LOCATION_FIELD, DETAILS_FIELD];
export default class AddEvent extends NavigationMixin(LightningElement) {
    @track eventRecord = {}
    @track errors = {}
    handleChange(event){
        try{
            const source = event.target.Name;
            const {name, value} = event.target;
            this.eventRecord[name] = value;
        }catch(error){
            console.error(error);
        }
        
    }

    handleSelect(event){
        try{
            let selectedRecId = event.detail.selectedRecordId;
            let parentField = event.detail.parentField;

            this.eventRecord[event.detail.parentField] = event.detail.selectedRecordId;
        }catch(error){
            console.error(error);
        }
        
    }

    createEvent(){
        let fields = {}
        fields[NAME_FIELD.fieldApiName] = this.eventRecord.Name__c;
        fields[ORGANIZER_FIELD.fieldApiName] = this.eventRecord.Event_Organizer__c;
        fields[START_DATE_FIELD.fieldApiName] = this.eventRecord.Start_DateTime__c;
        fields[END_DATE_FIELD.fieldApiName] = this.eventRecord.End_Date_Time__c;
        fields[MAX_ATTENDEE_FIELD.fieldApiName] = this.eventRecord.Max_Seats__c;
        fields[LOCATION_FIELD.fieldApiName] = this.eventRecord.Location__c;
        fields[DETAILS_FIELD.fieldApiName] = this.eventRecord.Event_Detail__c;
        
        const recordInput = {apiName: EVENT_OBJECT.objectApiName, fields}
        console.log('Calling recordInput');
        console.log(recordInput);
         createRecord(recordInput).then((result)=>{
             
             console.log('Record created: ' + result.id);
             this.dispatchEvent(new ShowToastEvent({
                 title: "Event created successfully",
                 message: 'Event Id: ' + result.id,
                 variant: 'success'
             }));

            this[NavigationMixin.Navigate]({
                 type: "standard__recordPage",
                 attributes: {
                     actionName: "view",
                     recordId: result.id
                 }
             })

         }).catch(error=>{
             console.log('Exception catched');
             this.errors = JSON.stringify(error)
             this.dispatchEvent(new ShowToastEvent({
                 title: "Error",
                 message: this.errors,
                 variant: 'error'
             }));
         })
    }

    handleCancel(){
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                actionName: "Home",
                objectApiName: "Event__c"
            }
        })
    }
    

}