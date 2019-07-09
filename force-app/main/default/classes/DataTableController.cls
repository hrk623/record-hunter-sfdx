public with sharing class DataTableController {
    public class DataTableControllerException extends Exception {}
    public class Error {
        @AuraEnabled public String message;
        @AuraEnabled public Boolean hasError = true;
        public Error(String message){
            this.message = message;
        }
    }

    @AuraEnabled
    public static String getRecords(String objectName, String fieldsJson, String recordIdsJson) {
        try {
            List<Field> fields = (List<Field>)JSON.deserialize(fieldsJson, List<Field>.class);
            List<String> recordIds = (List<String>)JSON.deserialize(recordIdsJson, List<String>.class);

            String query = 'SELECT Id';
            for (Field field : fields) {
                if ((!field.path.startsWith(field.objectName.toLowerCase()) || field.name.toLowerCase() != 'id')
                    && Schema.getGlobalDescribe().get(field.objectName).getDescribe().isAccessible()
                    && Schema.getGlobalDescribe().get(field.objectName).getDescribe().fields.getMap().get(field.name).getDescribe().isAccessible()) {
                        if (field.type.toUpperCase() == 'PICKLIST' || field.type.toUpperCase() == 'MULTIPICKLIST') {
                            query += ',TOLABEL(' + field.path + ')';
                        } else {
                            query += ',' + field.path;
                        }
                    }
            }
            query += ' FROM ' + objectName;
            query += ' WHERE Id IN (\'' + String.join(recordIds, '\',\'') + '\')';



            List<Sobject> olist = Database.query(query);
            return JSON.serialize(olist);
        } catch (Exception e) {
            return JSON.serialize(new Error(e.getMessage()));
        }
    }


    @AuraEnabled
    public static Object getFields(String objectName, String fieldNames) {
        try {
            if (String.isBlank(objectName)) throw new DataTableControllerException('Object name is not specified');
            if (String.isBlank(fieldNames)) throw new DataTableControllerException('Field name is not specified');


            List<Object> ret = new List<Object>();
            List<String> fieldNameList = fieldNames.split(',');

            for (String fieldName : fieldNameList) {
                ret.add(String.isBlank(fieldName) ? (Object)'' : new Field(objectName.trim() + '.' + fieldName.trim()));
            }
            return ret;
        } catch (Exception e) {
            return new Error(e.getMessage());
        }
    }

}