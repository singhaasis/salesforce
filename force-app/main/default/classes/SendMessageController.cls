public with sharing class SendMessageController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactDetails(Id contactId){
        try {
            List<Contact> contact = [SELECT FirstName, LastName,Phone,HomePhone,MobilePhone,OtherPhone,AssistantPhone, Email FROM Contact WHERE Id=:contactId LIMIT 1];
            return contact;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
   
@AuraEnabled(cacheable=true)
public static List<returnWrapper> getTask(String contactId,String toPhone){
    try {
        list<returnWrapper> wraperlist = new list<returnWrapper>();
        if(contactId!='' && toPhone!='')
        {

        
        List<Task> chat = [SELECT Subject,Status,WhoId,ActivityDate,CallDisposition, Description,CreatedDate FROM Task WHERE WhoId =: contactId AND CallDisposition = :toPhone AND  (Subject='SMS' OR Subject='SMS Received') Order By CreatedDate];
        system.debug('chat'+chat);
        if(!chat.isEmpty())
        {
            for(Task tsk:chat){
             returnWrapper returnWrapperObj = new returnWrapper();
              if(tsk.Subject=='SMS')
              {   
                returnWrapperObj.task = tsk;
                returnWrapperObj.groupDate = tsk.CreatedDate.format('EEEE dd MMMMM yyyy');
                returnWrapperObj.formattedDate = tsk.CreatedDate.format('dd MMM hh:mm a'); 
                returnWrapperObj.flag = true;
                returnWrapperObj.sent = tsk.Status=='Completed'?true:false;
                wraperlist.add(returnWrapperObj);
              }
              else{
                returnWrapperObj.task=tsk;
                returnWrapperObj.groupDate = tsk.CreatedDate.format('EEEE dd MMMMM yyyy');
                returnWrapperObj.formattedDate = tsk.CreatedDate.format('dd MMM hh:mm a'); 
                returnWrapperObj.flag=false;
                wraperlist.add(returnWrapperObj);   
              }
              
            }
         }
      
        }
        return wraperlist;
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}


@AuraEnabled
public static Task createTask(String message, Id recId, String toPhone){
    try {
                Task task = new Task();
                task.Subject ='SMS';
                task.CallDisposition=toPhone;
                task.Description=message;
                task.ActivityDate=system.today();
                task.WhoId = recId;
                task.OwnerId = UserInfo.getUserId();
                insert task;
                return task;
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}

  @AuraEnabled   
  public static string processSms(String tophNumber, String message, Id taskId){
    try{
      
        String  result = '';
        String phNumber = tophNumber;
        String accountSid='';      
        String token='';     
        String fromPhNumber='';
        String smsBody = message; 
        
        system.debug('smsBody'+smsBody);

        List< TwilioSmsCredentials__c> customObject=new List< TwilioSmsCredentials__c>();
        customObject=[ SELECT Name, AccountSid__c, SenderPhone__c, Token__c, Active__c FROM  TwilioSmsCredentials__c WHERE  Active__c=true];
        if(!customObject.isEmpty()){
              accountSid = customObject[0].AccountSid__c;        
              token = customObject[0].Token__c;        
              fromPhNumber = customObject[0].SenderPhone__c;   
        }         
        HttpRequest req = new HttpRequest();        
        req.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/'+accountSid+'/SMS/Messages.json');        
        req.setMethod('POST');        
        String VERSION  = '3.2.0';        
        req.setHeader('X-Twilio-Client', 'salesforce-' + VERSION);        
        req.setHeader('User-Agent', 'twilio-salesforce/' + VERSION);       
        req.setHeader('Accept', 'application/json');        
        req.setHeader('Accept-Charset', 'utf-8');        
        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf(accountSid+':' +token)));        
        req.setBody('To='+EncodingUtil.urlEncode(phNumber,'UTF-8')+'&From='+EncodingUtil.urlEncode(fromPhNumber,'UTF-8')+'&Body='+smsBody);        
        Http http = new Http();        
        HTTPResponse res = http.send(req);      
            System.debug(res.getBody());        
            if(res.getStatusCode() == 201){
                Task task = new Task();
                task.Id =taskId;
                task.Status ='Completed';
                Update task;
                result='Message sending Successful'; 
            } else {            
                result='Message sending Unsuccessful';
            }
            return result;        
        }
        catch(DmlException e) {
            return('The following exception has occurred: ' + e.getMessage());
        }
    }
    
    // @AuraEnabled(cacheable=true)
    //  public static List<Configuration__c> getConfiguration(){
    //      try {

    //         List<Configuration__c> configuration=new List<Configuration__c>();
    //         configuration=[ SELECT Id, Name, Background_Colour__c, Sent_Message_Background_Colour__c, Received_Message_Background_Colour__c, Sent_Text_Colour__c, Received_Text_Colour__c, Date_Time_Text_Colour__c FROM Configuration__c WHERE Name='SMS Configuration'];
    //         system.debug('config'+configuration);
    //         return configuration;
    //      } catch (Exception e) {
    //          throw new AuraHandledException(e.getMessage());
    //      }
    //  }

    public class returnWrapper{
        @AuraEnabled public Task task;
        @AuraEnabled public String groupDate;
        @AuraEnabled public string formattedDate;
        @AuraEnabled public Boolean flag;
        @AuraEnabled public Boolean sent;
    }
}