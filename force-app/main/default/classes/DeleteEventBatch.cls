public class DeleteEventBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'select Id, Name FROM Event__c WHERE Live__c = True AND End_Date_Time__c < LAST_N_MONTHS:2';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Event__c>scope){
        if (scope.size()>0){
            List<Database.DeleteResult> deleteResult = Database.delete(scope, false);
            for (Database.DeleteResult dr : deleteResult) {
                if (!dr.isSuccess()){
                    List<Database.Error> errors = dr.getErrors();
                    String errorInString = String.join(errors, ', ');
                    TransactionLogHandler.doHandleExceptionWithError(errorInString, 'DeleteEventBatch');
                }
            }
        }
    }
    
    public void finish(Database.BatchableContext bc){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddress = new List<String>();
        toAddress.add('deshpande.sagar1911@gmail.com');
        mail.setToAddresses(toAddress);
        mail.setSubject('Batch processing completed');
        mail.setSenderDisplayName('MAX FIT');
        mail.setHtmlBody('The DeleteEventBatch batch processing completed');
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
}