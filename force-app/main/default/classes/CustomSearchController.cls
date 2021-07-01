public with sharing class CustomSearchController {
    
    @AuraEnabled
    public static string searchRecords(String objectName, String fieldName, String keyword){
        String searchKey = keyword+'*';
        String returnigQuery = objectName + ' (Id, '+fieldName+')';
        String query = 'FIND :searchKey IN ALL FIELDS RETURNING ' + returnigQuery + ' LIMIT 2000';
        List<List<SObject>> sObjectLists = Search.query(query);
        return JSON.serialize(sObjectLists);
    }
}
