import { LightningElement, api, track } from 'lwc';

export default class SerachComponent extends LightningElement {
    @api searchLabel = 'Search Account';
    @api isrequired = "false";
    @api showLabel = "true";
    @track searchkeyword;

    renderedCallback(){
        if(this.isrequired==="false"){return;}
        if (this.isrequired==="true"){
            let picklistInfo = this.template.querySelector("lightning-input");
            picklistInfo.required=true;
            this.isrequired="false";
        }
    }

    handleChange(event){
        this.searchkeyword = event.target.value;
        console.log("HndleChange: " + event.target.value)
        var keyword = event.target.value;
        if (keyword && keyword.length >=2){
            let searchEvent = new CustomEvent("search", {
                detail: {value: keyword}
            });
            this.dispatchEvent(searchEvent);
        }
    }
}