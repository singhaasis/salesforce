public class EmployeeTriggerhandler {
    public static void handlerAfterInsert(List<Employee__c> Employees){
        Set<String> designationIdList = new Set<String>();
        for(Employee__c emp : Employees ){
            if(emp.Designation__c != null)
            designationIdList.add(emp.Designation__c);
        }
        if(!designationIdList.isEmpty())
        updateEmployeeCount(designationIdList);
    }
    
    public static void handlerAfterUpdate (List<Employee__c> updatedEmployees, List<Employee__c> unUpdatedEmployee){
        Set<String> designationIdList = new Set<String>();
        for(Employee__c emp : updatedEmployees ){
            for(Employee__c empOld : unUpdatedEmployee){
                if(emp.Designation__c != empOld.Designation__c || emp.Active__c != empOld.Active__c){
                   designationIdList.add(emp.Designation__c);
                   designationIdList.add(empOld.Designation__c);


                }
            }
        }
        if(!designationIdList.isEmpty())
        updateEmployeeCount(designationIdList);
    }
    
    public static void handlerAfterDelete (List<Employee__c> Employees){
        Set<String> designationIdList = new Set<String>();
        for(Employee__c emp : Employees ){
            if(emp.Designation__c != null )
            designationIdList.add(emp.Designation__c);
        }
        if(!designationIdList.isEmpty())
        updateEmployeeCount(designationIdList);
    }
    
    private static void updateEmployeeCount(Set<string> degIds){
    	List<Designation__c> designationList = new List<Designation__c>();
        designationList = [SELECT Id,Total_Employee_Count__c FROM Designation__c WHERE Id IN: degIds];
        List<Employee__c> employeeRecordList = new List<Employee__c>();
        for(Designation__c deg : designationList){
            employeeRecordList = [SELECT Id,Name,RecordTypeId, RecordType.Name FROM Employee__c WHERE Designation__c =: deg.Id AND Active__c = TRUE];
            
				Integer EmpCount = employeeRecordList.size();
            	deg.Total_Employee_Count__c = EmpCount;
            integer contractor = 0;
            for(Employee__c emp :employeeRecordList ){
                	if(emp.RecordType.Name == 'Contractor'){
                    	contractor = contractor+1;
                	}
            	}
             deg.Total_Contractor_Employee_Count__c	 = contractor;

            
        }
        
        update designationList;
    }
}