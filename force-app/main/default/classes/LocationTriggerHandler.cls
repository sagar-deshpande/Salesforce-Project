public class LocationTriggerHandler extends TriggerHandler {
	Static List<Location__c> newRecordList;
    
    public LocationTriggerHandler(){
        newRecordList = (List<Location__c>)Trigger.New;
    }
    
    public override void afterInsert(){
        for(Location__c loc : newRecordList){
        	verifyAddress(loc.Id);    
        }
        
    }
    @future(Callout=True)
    private static void verifyAddress(Id recordId){
        Location__c loc = [SELECT Id, Name, Street__c, City__c, Postal_Code__c, State__c, Verified__c FROM Location__c WHERE Id = :recordId];
        
// https://us-street.api.smartystreets.com/street-address?auth-id=69e307c8-a5e6-ea4a-002c-be34dbfc47aa&auth-token=mDF6O6ZD8o53rqdmLhJw&candidates=10&street=&city=&state=&zipcode=&match=invalid
// https://us-street.api.smartystreets.com/street-address?auth-id=69e307c8-a5e6-ea4a-002c-be34dbfc47aa&auth-token=mDF6O6ZD8o53rqdmLhJw&street=Bhausaheb Hire Marg&city=Mumbai&state=Maharashtra&zipcode=400006&match=invalid 		
        String baseUrl = 'https://us-street.api.smartystreets.com/street-address?auth-id=69e307c8-a5e6-ea4a-002c-be34dbfc47aa&auth-token=mDF6O6ZD8o53rqdmLhJw';
        baseUrl += '&street='+EncodingUtil.urlEncode(loc.Street__c, 'UTF-8');
        baseUrl += '&city='+EncodingUtil.urlEncode(loc.City__c, 'UTF-8');
        baseUrl += '&state='+EncodingUtil.urlEncode(loc.State__c, 'UTF-8');
        baseUrl += '&zipcode='+EncodingUtil.urlEncode(loc.Postal_Code__c, 'UTF-8');
        baseUrl += '&match=invalid';
        
        System.debug(baseUrl);
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
 		req.setEndpoint(baseUrl);           
        Http http = new Http();
            
        Httpresponse res = new HttpResponse();
            
        try{
            res = http.send(req);
            System.debug('Response: ' + res.getBody());
            if(res.getStatusCode() == 200 && res.getStatus() == 'OK'){
                if (!String.isBlank(res.getBody()) && res.getBody().length()>2 ){
                    loc.Verified__c = true;
                }else {
                    loc.Verified__c = false;
                }
                update loc;
            } else {
                TransactionLogHandler.doHandleExceptionWithError(res.getBody(), 'LocationTriggerHandler:verifyAddress');
            }
        } catch(System.Exception ex) {
            System.debug('Exception occured: ' + ex.getStackTraceString());
            TransactionLogHandler.doHandleException(ex, 'LocationTriggerHandler:verifyAddress');
        }
    }
}