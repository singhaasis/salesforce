public class NewsRestApiController {
@AuraEnabled
    public static Map<String, Object> getTopHeadlines(String countryCode){
        try {
        	Map<String, Object> newsJsonData = new Map<String, Object>();
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://newsapi.org/v2/top-headlines?country='+countryCode+'&apiKey=805bacd2cfba44e7887413366feb29a6');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            if(response.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                // Cast the values in the 'animals' key as a list
                
				newsJsonData = results;   
                system.debug('newsJsonData:'+newsJsonData);
            }
            return newsJsonData;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}