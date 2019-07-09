@IsTest
public class Test_SearchBoxController {
    static testMethod void getFields_SingleField() {
        Object result = SearchBoxController.getFields('Account', 'Name');
        List<Object> fields = (List<Object>)result;
        System.assertEquals(1, fields.size());
    }
    static testMethod void getFields_MultipleFields() {
        Object result = SearchBoxController.getFields('Account', 'Name,Type,Phone');
        List<Object> fields = (List<Object>)result;
        System.assertEquals(3, fields.size());
    }
    static testMethod void getFields_RedundantSpaces() {
        Object result = SearchBoxController.getFields('Account', ' Name  ,   Type ,Phone   ');
        List<Object> fields = (List<Object>)result;
        System.assertEquals(3, fields.size());
    }
    static testMethod void getFields_Empty() {
        Object result = SearchBoxController.getFields('', '');
        SearchBoxController.Error error = (SearchBoxController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_EmptyObject() {
        Object result = SearchBoxController.getFields('', 'Name');
        SearchBoxController.Error error = (SearchBoxController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_EmptyField() {
        Object result = SearchBoxController.getFields('Account', '');
        SearchBoxController.Error error = (SearchBoxController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_InvalidObject() {
        Object result = SearchBoxController.getFields('XXX', 'Name');
        SearchBoxController.Error error = (SearchBoxController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_InvalidField() {
        Object result = SearchBoxController.getFields('Account', 'XXX');
        SearchBoxController.Error error = (SearchBoxController.Error)result;
        System.assertEquals(true, error.hasError);
    }
    static testMethod void getFields_SomeInvalidFields() {
        Object result = SearchBoxController.getFields('Account', 'Name, XXX, AAA');
        SearchBoxController.Error error = (SearchBoxController.Error)result;
        System.assertEquals(true, error.hasError);
    }

    /*
* findRecords
*/

    static testMethod void findRecords_SingleField() {
        List<User> userList = [SELECT Id FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', '', JSON.serialize(fieldList), '1');
        Set<Id> ids = (Set<Id>)result;
        System.assertEquals(1, ids.size());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_MultipleField() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', '', JSON.serialize(fieldList), '1 AND 2');
        Set<Id> ids = (Set<Id>)result;
        System.assertEquals(1, ids.size());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }

    //
    static testMethod void findRecords_CustomLogic() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    //ZERO
    static testMethod void findRecords_CustomLogic_ZERO() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '0');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_MissingZeroValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', '', JSON.serialize(fieldList), '0');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    //ZERO LOGICALAND NUM
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALAND_NUM() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '0 AND 1');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALAND_NUM_MissingZeroValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', '', JSON.serialize(fieldList), '0 AND 1');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALAND_NUM_MissingValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '0 AND 1');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALAND_NUM_MissingAllValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', '', JSON.serialize(fieldList), '0 AND 1');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    //ZERO LOGICALAND LPAREN NUM RPAREN
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALAND_LPAREN_NUM_RPAREN() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '0 AND (1)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALAND_LPAREN_NUM_RPAREN_MissingZeroValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', '', JSON.serialize(fieldList), '0 AND (1)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALAND_LPAREN_NUM_RPAREN_MissingValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '0 AND (1)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALAND_LPAREN_NUM_RPAREN_MissingAllValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', '', JSON.serialize(fieldList), '0 AND (1)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    //ZERO LOGICALOR NUM
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALOR_NUM() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '0 OR 1');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALOR_NUM_MissingZeroValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', '', JSON.serialize(fieldList), '0 OR 1');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALOR_NUM_MissingValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '0 OR 1');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALOR_NUM_MissingAllValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User','', JSON.serialize(fieldList), '0 OR 1');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    //ZERO LOGICALOR LPAREN NUM RPAREN
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALOR_LPAREN_NUM_RPAREN() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '0 OR (1)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALOR_LPAREN_NUM_RPAREN_MissingZeroValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', '', JSON.serialize(fieldList), '0 OR (1)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALOR_LPAREN_NUM_RPAREN_MissingValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '0 OR (1)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_ZERO_LOGICALOR_LPAREN_NUM_RPAREN_MissingAllValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', '', JSON.serialize(fieldList), '0 OR (1)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    //NUM
    static testMethod void findRecords_CustomLogic_NUM() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '1');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_NUM_MissingValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '1');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    //NUM LOGICALAND NUM
    static testMethod void findRecords_CustomLogic_NUM_LOGICALAND_NUM() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '1 AND 2');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_NUM_LOGICALAND_NUM_MissingValue1() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '1 AND 2');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_NUM_LOGICALAND_NUM_MissingValue2() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '1 AND 2');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_NUM_LOGICALAND_NUM_MissingAllValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '1 AND 2');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    //NUM LOGICALOR NUM
    static testMethod void findRecords_CustomLogic_NUM_LOGICALOR_NUM() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '1 OR 2');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_NUM_LOGICALOR_NUM_MissingValue1() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '1 OR 2');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_NUM_LOGICALOR_NUM_MissingValue2() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '1 OR 2');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_NUM_LOGICALOR_NUM_MissingAllValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '1 OR 2');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }

    //LPAREN ZERO RPAREN
    static testMethod void findRecords_CustomLogic_LPAREN_ZERO_RPAREN() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '(0)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_LPAREN_ZERO_RPAREN_MissingZeroValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', '', JSON.serialize(fieldList), '(0)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    //LPAREN NUM RPAREN
    static testMethod void findRecords_CustomLogic_LPAREN_NUM_RPAREN() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '(1)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_LPAREN_NUM_RPAREN_MissingValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '(1)');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    //LPAREN LPAREN NUM RPAREN RPAREN
    static testMethod void findRecords_CustomLogic_LPAREN_LPAREN_NUM_RPAREN_RPAREN() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.value = u1.Id;
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '((1))');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }
    static testMethod void findRecords_CustomLogic_LPAREN_LPAREN_NUM_RPAREN_RPAREN_MissingValue() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];
        User u1 = userList[0];

        Field f1 = new Field('User.Id');
        f1.index = '1';

        Field f2 = new Field('User.LastName');
        f2.value = u1.LastName;
        f2.index = '2';

        List<Field> fieldList = new List<Field>();
        fieldList.add(f1);
        fieldList.add(f2);

        Test.setFixedSearchResults(new List<Id>{u1.Id});
        Test.startTest();
        Object result = SearchBoxController.findRecords('User', u1.LastName, JSON.serialize(fieldList), '((1))');
        Set<Id> ids = (Set<Id>)result;
        System.assert(!ids.isEmpty());
        System.assert(ids.contains(u1.Id));
        Test.stopTest();
    }



    static testMethod void getDefaultValues() {
        List<User> userList = [SELECT Id, LastName FROM User LIMIT 1];

        Test.startTest();
        Object result = SearchBoxController.getDefaultValues(userList[0].Id,  'aaaa, LastName, Address , ,');
        List<String> values = (List<String>)result;
        System.assertEquals(values[0], 'aaaa');
        System.assertEquals(values[1], userList[0].LastName);
        Test.stopTest();
    }


}