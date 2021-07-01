@isTest
public class DeleteEventBatchTest {
	@TestSetup
    public static void setupData(){
        Event_Organizer__c org = new Event_Organizer__c(
        	Name='Test Organizer',
        	Phone__c = '1234567890',
        	Email__c = 'sagdes@gmail.com');
        insert org;
        List<Event__c> eventList = new List<Event__c>();
        for (Integer i=0; i<=200;i++){
        	Event__c e1 = new Event__c(
            	Name__c='Test Eventi'+i, 
            	Event_Organizer__c = org.Id,
            	Event_Type__c = 'Virtual',
            	Frequency__c = 'Weekly',
            	Max_Seats__c = 100,
            	Recurring__c = true,
            	Live__c = true,
            	Start_DateTime__c = System.now().addMonths(-4),
            	End_Date_Time__c = System.now().addMonths(-4).addDays(2)
        	);  
            Event__c e2 = new Event__c(
            	Name__c='Test Eventi'+(i+100), 
            	Event_Organizer__c = org.Id,
            	Event_Type__c = 'Virtual',
            	Frequency__c = 'Weekly',
            	Max_Seats__c = 100,
            	Recurring__c = true,
            	Live__c = true,
            	Start_DateTime__c = System.now().addMonths(-1),
            	End_Date_Time__c = System.now().addMonths(-1).addDays(2)
        	); 
            eventList.add(e1);
            eventList.add(e2);
        }
        insert eventList;
        
    }
    
    @isTest
    static void sendDeleteEventTest(){
        Try{
            Test.startTest();
            	String jobId = Database.executeBatch(new DeleteEventBatch(), 250);
            test.stopTest();
            System.assertEquals(0, [SELECT count() FROM Event__c WHERE Live__c = True AND End_Date_Time__c < LAST_N_MONTHS:2]);
        }
        catch(System.Exception ex){
            
        }
    }
}