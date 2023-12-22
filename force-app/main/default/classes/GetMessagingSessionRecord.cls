public class GetMessagingSessionRecord {
    @InvocableMethod(label='Get Messaging Session Record' description='Retrieves the just created messaging session record')
    public static List<Account> getMessagingSessionRecord() {
        List<Account> results = new List<Account>();
        
        List<Account> messagingSessions = [SELECT Id, Name FROM Account ORDER BY Id DESC LIMIT 1];
        
      
        
        return messagingSessions;
    }
    
   }