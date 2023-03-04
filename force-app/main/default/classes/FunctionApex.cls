public with sharing class FunctionApex {
    public static void test() {
        functions.Function myFunction = functions.Function.get('functions_recipes.myfunction');
        // Pass a callback to Function.invoke to perform an asynchronous invocation.
        functions.FunctionInvocation invocation = myFunction.invoke('', new DemoCallback());
    }

    public class DemoCallback implements functions.FunctionCallback {
        public void handleResponse(functions.FunctionInvocation result) {

            // Handle result of function invocation
            String jsonResponse = result.getResponse();
            System.debug('Got response ' + jsonResponse);

            // Log error, if applicable
            if (result.getStatus() == functions.FunctionInvocationStatus.ERROR) {
                functions.FunctionInvocationError resultError = result.getError();
                if (resultError != null) {
                    System.debug('Error type: ' + resultError.getType());
                    System.debug('Error message: ' + resultError.getMessage());
                } else {
                    System.debug('Error: UNKNOWN');
                }
                return;
            }
            // Successful response, deserialize the response to an Apex object.
            Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
            Boolean done = (Boolean) parsedJson.get('done');
            Integer totalSize = (Integer) parsedJson.get('totalSize');
            List<Object> records = (List<Object>) parsedJson.get('records');

            List<Record> recordList = new List<Record>();

            for (Object recordObj : records) {
                Map<String, Object> record = (Map<String, Object>) recordObj;
                Map<String, Object> fields = (Map<String, Object>) record.get('fields');

                Record r = new Record();
                r.id = (String) fields.get('id');
                r.name = (String) fields.get('name');
                r.type = (String) record.get('type');

                recordList.add(r);
            }
            system.debug(recordList);
        }
    }
    public class Record {
        public String id;
        public String name;
        public String type;
    }
}