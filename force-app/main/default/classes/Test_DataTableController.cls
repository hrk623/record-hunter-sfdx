@IsTest
public class Test_DataTableController {
    static testMethod void getFields_SingleField() {
        Object result = DataTableController.getFields('Account', 'Name');
        List<Object> fields = (List<Object>)result;
        System.assertEquals(1, fields.size());
    }
    static testMethod void getFields_MultipleFields() {
        Object result = DataTableController.getFields('Account', 'Name,Type,Phone');
        List<Object> fields = (List<Object>)result;
        System.assertEquals(3, fields.size());
    }
    static testMethod void getFields_RedundantSpaces() {
        Object result = DataTableController.getFields('Account', ' Name  ,   Type ,Phone   ');
        List<Object> fields = (List<Object>)result;
        System.assertEquals(3, fields.size());
    }
    static testMethod void getFields_Empty() {
        Object result = DataTableController.getFields('', '');
        DataTableController.Error error = (DataTableController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_EmptyObject() {
        Object result = DataTableController.getFields('', 'Name');
        DataTableController.Error error = (DataTableController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_EmptyField() {
        Object result = DataTableController.getFields('Account', '');
        DataTableController.Error error = (DataTableController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_InvalidObject() {
        Object result = DataTableController.getFields('XXX', 'Name');
        DataTableController.Error error = (DataTableController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_InvalidField() {
        Object result = DataTableController.getFields('Account', 'XXX');
        DataTableController.Error error = (DataTableController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_SomeInvalidFields() {
        Object result = DataTableController.getFields('Account', 'Name, XXX, AAA');
        DataTableController.Error error = (DataTableController.Error)result;
        System.assertEquals(true, error.hasError);
    }

    static testMethod void getRecords() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];

        Field f1 = new Field('User.LastName');

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);

        Test.startTest();
        String result = DataTableController.getRecords('User', JSON.serialize(fieldList), JSON.serialize((new Map<Id, User>(userList)).keySet()));
        List<User> resultedUsers = (List<User>)JSON.deserialize(result, List<User>.class);
        System.assertEquals(resultedUsers[0].LastName, userList[0].LastName);
        Test.stopTest();
    }
}