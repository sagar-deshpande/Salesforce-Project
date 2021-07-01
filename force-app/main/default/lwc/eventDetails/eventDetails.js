import { LightningElement, api, track } from 'lwc';
import getSpeaker from '@salesforce/apex/EventDetailsController.getSpeakers'
const columns = [
    {label: 'Name', fieldName: 'Name'},
    {label: 'Email', fieldName: 'Email'},
    {label: 'Phone', fieldName: 'Phone'},
    {label: 'Company', fieldName: 'CompanyName'}
]
export default class EventDetails extends LightningElement {
    @api recordId
    @track spealerList = []
    @track errors
    columnList = columns;
    errMsg;
    
    handleSpeakerActive(){
    //     console.log("In handleSpeakerActive");
    //     getSpeaker({
    //         eventId: this.recordId
    //     }).then((result)=>{
    //         console.log("Getting speaker list");
    //         console.log(JSON.stringify(result))
    //         //this.spealerList = result;
    //         console.log(this.spealerList === undefined)
    //         this.errors = undefined
    //         if(result != undefined) {
    //             result.forEach(speaker => {
    //                 let data = {}
    //                 data.id = speaker.Speaker__r.Id
    //                 data.Name = speaker.Speaker__r.Name;
    //                 data.Email = speaker.Speaker__r.Email__c;
    //                 data.Phone = speaker.Speaker__r.Phone__c;
    //                 if(speaker.Speaker__r.Company__c != undefined){
    //                     data.CompanyName = speaker.Speaker__r.Company__c;
    //                 } else{
    //                     data.CompanyName = 'NA';
    //                 }
                    
    //                 this.spealerList.push(data)
    //             });
    //             console.log('------------------------------')
    //             console.log(JSON.stringify(this.spealerList));
    //         }
            
    //     }).catch((error)=>{
    //         this.errors = error;
    //         this.errMsg = JSON.stringify(this.errors)
    //         console.log(this.errors)
    //         this.spealerList = undefined
    //     })


    getSpeakers({
        eventId: this.recordId
      })
        .then((result) => {
          result.forEach((speaker) => {
            speaker.Name = speaker.Speaker__r.Name;
            speaker.Email = "*********@gmail.com";
            speaker.Phone = speaker.Speaker__r.Phone__c;
            speaker.Picture__c = speaker.Speaker__r.Picture__c;
            speaker.About_Me__c = speaker.Speaker__r.About_Me__c;
            speaker.CompanyName = speaker.Speaker__r.Company__c;
          });
          this.speakerList = result;
          window.console.log(" result ", this.result);
          this.errors = undefined;
        })
        .catch((err) => {
          this.errors = err;
          this.speakerList = undefined;
          window.console.log(" err ", this.errors);
        });
  
    }
}