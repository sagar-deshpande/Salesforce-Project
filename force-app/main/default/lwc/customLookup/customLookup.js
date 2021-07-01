import { LightningElement, api, track } from 'lwc';
import searchRecords from '@salesforce/apex/CustomSearchController.searchRecords'
export default class CustomLookup extends LightningElement {
    @api objectName = "Account";
    @api fieldName = "Name";
    @api iconname = "standard:record";
    @api label = "Account";
    @api parentFieldId = "AccountId"
    
    @track records;
    @track selectedRecord;

    handleSearch(event){
        var searchVal = event.detail.value;
        console.log(searchVal);
        searchRecords({
            objectName: this.objectName,
            fieldName: this.fieldName,
            keyword: searchVal
        }).then(data=>{
            if(data){
                let parsedResponse = JSON.parse(data);
                let searchRecordList = parsedResponse[0];
                for (let i=0; i<searchRecordList.lenghth; i++) {
                    let record = searchRecordList[i];
                    record.Name = record[this.fieldName];
                }
                this.records = searchRecordList;
            }
        }).catch(error=>{
            window.console.log(error);
        })
    }

    handleSelect(event){
        var selectedVal = event.detail.selRec;
        console.log((selectedVal===undefined));
        this.selectedRecord = selectedVal;
        this.dispatchEvent(new CustomEvent('select', ({
            detail: {
                selectedRecordId: this.selectedRecord.Id, parentField: this.parentFieldId
            }
        })));
    }

    handleRemove(){
        this.selectedRecord = undefined
        this.records = null
        this.dispatchEvent(new CustomEvent('select', ({
            detail: {
                selectedRecordId: undefined, parentField: this.parentFieldId
            }
        })));
    }
}