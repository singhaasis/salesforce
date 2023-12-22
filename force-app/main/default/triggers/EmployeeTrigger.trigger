trigger EmployeeTrigger on Employee__c (after insert, after update, after delete) {
    if(trigger.isinsert && trigger.isafter){
        EmployeeTriggerhandler.handlerAfterInsert(trigger.new);
    }
    if(trigger.isupdate && trigger.isafter){
        EmployeeTriggerhandler.handlerAfterUpdate (trigger.new, trigger.old);
    }
    if(trigger.isdelete && trigger.isafter){
        EmployeeTriggerhandler.handlerAfterDelete (trigger.old);
    }
}