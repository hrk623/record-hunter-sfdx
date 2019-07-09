@IsTest
public class Test_LocationFilterController {
    static testMethod void getFields_SingleField() {
        Object result = LocationFilterController.getFields('Account', 'Name');
        List<Object> fields = (List<Object>)result;
        System.assertEquals(1, fields.size());
    }
    static testMethod void getFields_MultipleFields() {
        Object result = LocationFilterController.getFields('Account', 'Name,Type,Phone');
        List<Object> fields = (List<Object>)result;
        System.assertEquals(3, fields.size());
    }
    static testMethod void getFields_RedundantSpaces() {
        Object result = LocationFilterController.getFields('Account', ' Name  ,   Type ,Phone   ');
        List<Object> fields = (List<Object>)result;
        System.assertEquals(3, fields.size());
    }
    static testMethod void getFields_Empty() {
        Object result = LocationFilterController.getFields('', '');
        LocationFilterController.Error error = (LocationFilterController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_EmptyObject() {
        Object result = LocationFilterController.getFields('', 'Name');
        LocationFilterController.Error error = (LocationFilterController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_EmptyField() {
        Object result = LocationFilterController.getFields('Account', '');
        LocationFilterController.Error error = (LocationFilterController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_InvalidObject() {
        Object result = LocationFilterController.getFields('XXX', 'Name');
        LocationFilterController.Error error = (LocationFilterController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_InvalidField() {
        Object result = LocationFilterController.getFields('Account', 'XXX');
        LocationFilterController.Error error = (LocationFilterController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_SomeInvalidFields() {
        Object result = LocationFilterController.getFields('Account', 'Name, XXX, AAA');
        LocationFilterController.Error error = (LocationFilterController.Error)result;
        System.assertEquals(true, error.hasError);
    }

    /*
* getRecords
*/
    static testMethod void getRecords() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];

        Field f1 = new Field('User.LastName');

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);

        Test.startTest();
        String result = (String)LocationFilterController.getRecords('User', JSON.serialize(fieldList), JSON.serialize((new Map<Id, User>(userList)).keySet()));
        List<User> resultedUsers = (List<User>)JSON.deserialize(result, List<User>.class);
        System.assertEquals(resultedUsers[0].LastName, userList[0].LastName);
        Test.stopTest();
    }


    /*
* filterRecords
*/

    static testMethod void filterRecords_SingleRecord() {
        List<User> userList = [SELECT Id FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);

        String recordIdsJson = JSON.serialize((new Map<Id, User>(userList)).keySet());
        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        String result = (String)LocationFilterController.filterRecords('User', recordIdsJson, JSON.serialize(fieldList), '0 AND 1');
        Set<Id> ids = (Set<Id>)JSON.deserialize(result, Set<Id>.class);
        System.assertEquals(1, ids.size());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }

    static testMethod void getDefaultValues() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];

        Test.startTest();
        Object result = LocationFilterController.getDefaultValues(userList[0].Id,  'aaaa, LastName, Address , ,');
        List<String> values = (List<String>)result;
        System.assertEquals(values[0], 'aaaa');
        System.assertEquals(values[1], userList[0].LastName);
        Test.stopTest();
    }
}