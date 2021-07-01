public class TransactionLogHandler {
    public static void doHandleException(System.Exception ex, String ProcessName) {
        Error_Log__c errLog = new Error_Log__c(
        	Log_Details__c = ex.getStackTraceString() + '<br/>' + ex.getMessage()+ +'<br/>' + ex.getCause() + '<br/>' + ex.getTypeName() + '<br/>' + ex.getLineNumber(),
            Lod_DateTime__c = System.now(),
        	Process_Name__c = ProcessName);
        
        insert errLog;
    }
    
    public static void doHandleExceptionWithError(String errors, String ProcessName) {
        Error_Log__c errLog = new Error_Log__c(
        	Log_Details__c = errors,
            Lod_DateTime__c = System.now(),
        	Process_Name__c = ProcessName);
        
        insert errLog;
    }
}