public class LocationFilterController {
    public class LocationFilterControllerException extends Exception {}
    public class Error {
        @AuraEnabled public String message;
        @AuraEnabled public Boolean hasError = true;
        public Error(String message){
            this.message = message;
        }
    }

    @AuraEnabled
    public static Object getDefaultValues(String recordId, String fieldNamesOrDefaultValues) {
        try {
            Id recordIdFromString = recordId;
            String objectName = recordIdFromString.getSObjectType().getDescribe().getName();

            if (!Schema.getGlobalDescribe().get(objectName).getDescribe().isAccessible()) throw new LocationFilterControllerException('You have no access right to this sobject.');

            List<String> fieldNameOrDefaultValueList = fieldNamesOrDefaultValues.split(',');
            Set<String> fieldNameSet = new Set<String> {'Id'};
                for (String fieldNameOrDefaultValue : fieldNameOrDefaultValueList) {
                    if (String.isNotBlank(fieldNameOrDefaultValue)
                        && Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().containsKey(fieldNameOrDefaultValue.trim())
                        && Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldNameOrDefaultValue.trim()).getDescribe().isAccessible()) {
                            fieldNameSet.add(fieldNameOrDefaultValue);
                        }
                }

            SObject record = null;
            if (!fieldNameSet.isEmpty()) {
                record = Database.query('SELECT ' + String.join(new List<String>(fieldNameSet), ',') + ' FROM ' + objectName + ' WHERE Id = \'' + recordId + '\'');
            }

            List<String> defaultValueList = new List<String>();
            for (String fieldNameOrDefaultValue : fieldNameOrDefaultValueList) {
                if (String.isNotBlank(fieldNameOrDefaultValue)
                    && Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().containsKey(fieldNameOrDefaultValue.trim())) {
                        if (Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldNameOrDefaultValue.trim()).getDescribe().isAccessible()) {
                            Object value = record.get(fieldNameOrDefaultValue.trim());
                            if (value == null) {
                                defaultValueList.add('');
                            } else if (value instanceof Datetime) {
                                Datetime dt = (DateTime)value;
                                defaultValueList.add(dt.format('yyyy-MM-dd\'T\'HH:mm:ss'));
                            } else {
                                defaultValueList.add(String.valueOf(value));
                            }
                        } else {
                            defaultValueList.add('');
                        }
                    } else {
                        defaultValueList.add(fieldNameOrDefaultValue);
                    }
            }
            return defaultValueList;
        } catch (Exception e) {
            return new Error(e.getMessage());
        }
    }

    @AuraEnabled
    public static Object getRecords(String objectName, String fieldsJson, String recordIdsJson) {
        try {
            List<Field> fields = (List<Field>)JSON.deserialize(fieldsJson, List<Field>.class);
            List<String> recordIds = (List<String>)JSON.deserialize(recordIdsJson, List<String>.class);

            String query = 'SELECT Id';
            for (Field field : fields) {
                if (!field.path.startsWith(field.objectName.toLowerCase()) || field.name.toLowerCase() != 'id'
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
    public static Object filterRecords(String objectName, String recordIdsJson, String fieldsJson, String customLogic) {
        try {

            if (!Schema.getGlobalDescribe().get(objectName).getDescribe().isAccessible()) return JSON.serialize(new Set<Id>());

            List<String> recordIds = (List<String>)JSON.deserialize(recordIdsJson, List<String>.class);

            Map<String, Field> fields = new Map<String, Field>();

            List<Field> fieldList = (List<Field>)JSON.deserialize(fieldsJson, List<Field>.class);
            System.debug(fieldList);
            for(Field field : fieldList) {
                fields.put(field.index, field);
            }

            // Build conditions for WHERE clause
            List<Lexer.Token> tokens = Lexer.tokenize(customLogic);
            List<Lexer.Token> reducedToken = reduceTokens(tokens, fields, true);

            String conditions = '';
            for (Lexer.Token token : reducedToken) {
                if (token.kind == Lexer.Kind.ZERO) {
                    conditions += 'Id in (\'' + String.join(recordIds, '\',\'') + '\')';
                } else if (token.kind == Lexer.Kind.NUM) {
                    conditions += fields.get(token.lexeme).getWhereCondition();
                } else {
                    conditions += ' ' + token.lexeme + ' ';
                }
            }

            // Find records by conditions
            String query = 'SELECT Id FROM ' + objectName ;
            query += String.isNotEmpty(conditions) ? ' WHERE ' + conditions : '';

            return JSON.serialize((new Map<Id, SObject>(Database.query(query))).keySet());
        } catch (Exception e) {
            return JSON.serialize(new Error(e.getMessage()));
        }
    }

    @AuraEnabled
    public static Object getFields(String objectName, String fieldNames) {
        try {
            if (String.isBlank(objectName)) throw new LocationFilterControllerException('Object name is not specified');
            if (String.isBlank(fieldNames)) throw new LocationFilterControllerException('Field name is not specified');

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

    private static List<Lexer.Token> reduceTokens(List<Lexer.Token> tokens, Map<String, Field> fields, Boolean isZeroIncluded) {
        List<Lexer.Token> reducedTokens = new List<Lexer.Token>();
        Lexer.Token prev = null, token;
        for (Integer i = 0; i < tokens.size(); i++) {
            token = tokens[i];
            prev = reducedTokens.size() > 0 ? reducedTokens[reducedTokens.size() - 1] : null;

            if (token.kind == Lexer.Kind.NUM && !fields.get(token.lexeme).hasCondition()) continue;
            else if (token.kind == Lexer.Kind.ZERO && !isZeroIncluded) continue;
            else if (token.kind == Lexer.Kind.LOGICALAND) {
                if (prev == null) continue;
                else if (prev.kind == Lexer.Kind.RPAREN) reducedTokens.add(token);
                else if (prev.kind == Lexer.Kind.NUM)    reducedTokens.add(token);
                else if (prev.kind == Lexer.Kind.ZERO)   reducedTokens.add(token);
            } /*else if (token.kind == Lexer.Kind.LOGICALOR) {
                if (prev == null) continue;
                else if (prev.kind == Lexer.Kind.LOGICALAND) reducedTokens.set(reducedTokens.size() - 1, token);
                else if (prev.kind == Lexer.Kind.RPAREN)     reducedTokens.add(token);
                else if (prev.kind == Lexer.Kind.NUM)        reducedTokens.add(token);
                else if (prev.kind == Lexer.Kind.ZERO)       reducedTokens.add(token);
            } else if (token.kind == Lexer.Kind.RPAREN) {
                if (prev == null) continue;
                else if (prev.kind == Lexer.Kind.LOGICALAND) reducedTokens.set(reducedTokens.size() - 1, token);
                else if (prev.kind == Lexer.Kind.LOGICALOR)  reducedTokens.set(reducedTokens.size() - 1, token);
                else if (prev.kind == Lexer.Kind.RPAREN)     reducedTokens.add(token);
                else if (prev.kind == Lexer.Kind.LPAREN)     reducedTokens.remove(reducedTokens.size() - 1);
                else if (prev.kind == Lexer.Kind.NUM)        reducedTokens.add(token);
                else if (prev.kind == Lexer.Kind.ZERO)       reducedTokens.add(token);
            } else if (token.kind == Lexer.Kind.LPAREN) {
                if (prev == null) reducedTokens.add(token);
                else if (prev.kind == Lexer.Kind.LOGICALAND) reducedTokens.add(token);
                else if (prev.kind == Lexer.Kind.LOGICALOR)  reducedTokens.add(token);
                else if (prev.kind == Lexer.Kind.LPAREN)     reducedTokens.add(token);
            } */else {
                reducedTokens.add(token);
            }
        }
        prev = reducedTokens.size() > 0 ? reducedTokens[reducedTokens.size() - 1] : null;
        if (prev == null) {}
        else if (prev.kind == Lexer.Kind.LOGICALAND) reducedTokens.remove(reducedTokens.size() - 1);
        else if (prev.kind == Lexer.Kind.LOGICALOR)  reducedTokens.remove(reducedTokens.size() - 1);

        return reducedTokens;
    }
}