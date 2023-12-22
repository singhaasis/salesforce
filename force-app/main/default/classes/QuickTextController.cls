public with sharing class QuickTextController {
    @AuraEnabled(cacheable=true)
    public static List<TwilioSmsCredentials__c> getAllAccountCredentials(){
        try {
            return [SELECT Id, Name, Active__c, AccountSid__c, SenderPhone__c, Token__c FROM TwilioSmsCredentials__c ];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<TwilioSmsCredentials__c> registerUpdateAccountCredentials(TwilioSmsCredentials__c inputCred){
        try {
            List<TwilioSmsCredentials__c> result =new List<TwilioSmsCredentials__c>();
            boolean isUpdate = false;
            List<TwilioSmsCredentials__c> credToUpdate = new  List<TwilioSmsCredentials__c>();
            List<TwilioSmsCredentials__c> credentials = [SELECT Id, Name, Active__c, AccountSid__c, SenderPhone__c, Token__c FROM TwilioSmsCredentials__c WHERE SenderPhone__c =: inputCred.SenderPhone__c];
            for (TwilioSmsCredentials__c cred : credentials) {
                if(cred.SenderPhone__c == inputCred.SenderPhone__c){
                    cred.Name = inputCred.Name;
                    cred.Active__c = inputCred.Active__c;
                    cred.AccountSid__c = inputCred.AccountSid__c;
                    cred.SenderPhone__c = inputCred.SenderPhone__c;
                    cred.Token__c = inputCred.Token__c;
                    credToUpdate.add(cred);
                }
            }
            if(credToUpdate.isEmpty()){
                insert inputCred;
                result.add(inputCred);
            }else{
                update credToUpdate;
                result = credToUpdate;
            }
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage()+' '+e.getLineNumber());
        }
    }
}