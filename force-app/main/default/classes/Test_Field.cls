@isTest
public class Test_Field {
    static testMethod void createEmptyField() {
        Field field = new Field();
        System.assertEquals(null, field.objectName);
        System.assertEquals(null, field.name);
        System.assertEquals(null, field.path);
        System.assertEquals(null, field.type);
    }
    static testMethod void createSimpleField_Address() {
        Field field = new Field('Account.BillingAddress');
        System.assertEquals('Account', field.objectName);
        System.assertEquals('BillingAddress', field.name);
        System.assertEquals('account.billingaddress', field.path);
        System.assertEquals('ADDRESS', field.type);
    }
    static testMethod void createSimpleField_Base64() {
        Field field = new Field('ContentVersion.VersionData');
        System.assertEquals('ContentVersion', field.objectName);
        System.assertEquals('VersionData', field.name);
        System.assertEquals('contentversion.versiondata', field.path);
        System.assertEquals('BASE64', field.type);
    }
    static testMethod void createSimpleField_Boolean() {
        Field field = new Field('Contact.DoNotCall');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('DoNotCall', field.name);
        System.assertEquals('contact.donotcall', field.path);
        System.assertEquals('BOOLEAN', field.type);
    }
    static testMethod void createSimpleField_Combobox() {
        Field field = new Field('Event.Subject');
        System.assertEquals('Event', field.objectName);
        System.assertEquals('Subject', field.name);
        System.assertEquals('event.subject', field.path);
        System.assertEquals('COMBOBOX', field.type);
    }
    static testMethod void createSimpleField_DataCategoryGroupReference() {
        // NOT TESTABLE - There is no standard DataCategoryGroupReference field.
    }
    static testMethod void createSimpleField_Date() {
        Field field = new Field('Opportunity.CloseDate');
        System.assertEquals('Opportunity', field.objectName);
        System.assertEquals('CloseDate', field.name);
        System.assertEquals('opportunity.closedate', field.path);
        System.assertEquals('DATE', field.type);
    }
    static testMethod void createSimpleField_DateTime() {
        Field field = new Field('Case.ClosedDate');
        System.assertEquals('Case', field.objectName);
        System.assertEquals('ClosedDate', field.name);
        System.assertEquals('case.closeddate', field.path);
        System.assertEquals('DATETIME', field.type);
    }
    static testMethod void createSimpleField_Double() {
        Field field = new Field('Opportunity.TotalOpportunityQuantity');
        System.assertEquals('Opportunity', field.objectName);
        System.assertEquals('TotalOpportunityQuantity', field.name);
        System.assertEquals('opportunity.totalopportunityquantity', field.path);
        System.assertEquals('DOUBLE', field.type);
    }
    static testMethod void createSimpleField_Email() {
        Field field = new Field('Contact.Email');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('Email', field.name);
        System.assertEquals('contact.email', field.path);
        System.assertEquals('EMAIL', field.type);
    }
    static testMethod void createSimpleField_EncryptedString() {
        // NOT TESTABLE - There is no standard EncryptedString field.
    }
    static testMethod void createSimpleField_ID() {
        Field field = new Field('Contact.Id');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('Id', field.name);
        System.assertEquals('contact.id', field.path);
        System.assertEquals('ID', field.type);
    }
    static testMethod void createSimpleField_Integer() {
        Field field = new Field('Account.NumberOfEmployees');
        System.assertEquals('Account', field.objectName);
        System.assertEquals('NumberOfEmployees', field.name);
        System.assertEquals('account.numberofemployees', field.path);
        System.assertEquals('INTEGER', field.type);
    }
    static testMethod void createSimpleField_MultiPicklist() {
        // NOT TESTABLE - There is no standard MultiPicklist field.
    }
    static testMethod void createSimpleField_Percent() {
        Field field = new Field('Opportunity.Probability');
        System.assertEquals('Opportunity', field.objectName);
        System.assertEquals('Probability', field.name);
        System.assertEquals('opportunity.probability', field.path);
        System.assertEquals('PERCENT', field.type);
    }
    static testMethod void createSimpleField_Phone() {
        Field field = new Field('Contact.Phone');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('Phone', field.name);
        System.assertEquals('contact.phone', field.path);
        System.assertEquals('PHONE', field.type);
    }
    static testMethod void createSimpleField_Picklist() {
        Field field = new Field('Contact.LeadSource');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('LeadSource', field.name);
        System.assertEquals('contact.leadsource', field.path);
        System.assertEquals('PICKLIST', field.type);
    }
    static testMethod void createSimpleField_Reference() {
        Field field = new Field('Contact.AccountId');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('AccountId', field.name);
        System.assertEquals('contact.accountid', field.path);
        System.assertEquals('REFERENCE', field.type);
    }
    static testMethod void createSimpleField_String() {
        Field field = new Field('Contact.Title');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('Title', field.name);
        System.assertEquals('contact.title', field.path);
        System.assertEquals('STRING', field.type);
    }
    static testMethod void createSimpleField_StringAsName() {
        Field field = new Field('Contact.Name');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('Name', field.name);
        System.assertEquals('contact.name', field.path);
        System.assertEquals('STRING', field.type);
        System.assertEquals(true, field.isNameField);
    }
    static testMethod void createSimpleField_StringAsSubject() {
        Field field = new Field('Event.Subject');
        System.assertEquals('Event', field.objectName);
        System.assertEquals('Subject', field.name);
        System.assertEquals('event.subject', field.path);
        System.assertEquals('COMBOBOX', field.type);
        System.assertEquals(true, field.isNameField);
    }
    static testMethod void createSimpleField_TextArea() {
        // NOT TESTABLE - There is no standard field with Long Text under 255 characters.
    }
    static testMethod void createSimpleField_LongTextArea() {
        Field field = new Field('Contact.Description');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('Description', field.name);
        System.assertEquals('contact.description', field.path);
        System.assertEquals('TEXTAREA', field.type);
        System.assertEquals(false, field.isFilterable);
    }
    static testMethod void createSimpleField_Time() {
        // NOT TESTABLE - There is no standard Time field.
    }
    static testMethod void createSimpleField_URL() {
        Field field = new Field('Account.Website');
        System.assertEquals('Account', field.objectName);
        System.assertEquals('Website', field.name);
        System.assertEquals('account.website', field.path);
        System.assertEquals('URL', field.type);
    }
    static testMethod void createSimpleField_RandomCase() {
        Field field = new Field('CoNtaCt.TItlE');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('Title', field.name);
        System.assertEquals('contact.title', field.path);
        System.assertEquals('STRING', field.type);
    }
    static testMethod void createSimpleField_RedundantSpaces() {
        Field field = new Field('  Contact.Title  ');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('Title', field.name);
        System.assertEquals('contact.title', field.path);
        System.assertEquals('STRING', field.type);
    }
    static testMethod void createSimpleField_checkAccessibility () {
        String uniqueUserName = 'chatterfreeuser' + DateTime.now().getTime() + '@recordhuntertest.com';
        List<Profile> profiles = [SELECT Id FROM Profile WHERE Name='Chatter Free User'];
        if (!profiles.isEmpty()) {
            User u = new User(Alias = 'cfree', Email='cfree@recordhuntertest.com',
                              EmailEncodingKey='UTF-8', LastName='Free', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = profiles[0].Id,
                              TimeZoneSidKey='America/Los_Angeles',
                              UserName=uniqueUserName);
            System.runAs(u) {
                Field field = new Field('Account.Name');
                System.assertEquals(false,  field.isAccessible);
            }
        }
    }
    static testMethod void createReferencedField_Polymophic() {
        Field field = new Field('Event.WhatId:Opportunity.Name');
        System.assertEquals('Opportunity', field.objectName);
        System.assertEquals('Name', field.name);
        System.assertEquals('event.what.name', field.path);
        System.assertEquals('STRING', field.type);
    }
    static testMethod void createReferencedField_lavel1() {
        Field field = new Field('Case.ContactId.Name');
        System.assertEquals('Contact', field.objectName);
        System.assertEquals('Name', field.name);
        System.assertEquals('case.contact.name', field.path);
        System.assertEquals('STRING', field.type);
    }
    static testMethod void createReferencedField_lavel2() {
        Field field = new Field('Case.ContactId.AccountId.Name');
        System.assertEquals('Account', field.objectName);
        System.assertEquals('Name', field.name);
        System.assertEquals('case.contact.account.name', field.path);
        System.assertEquals('STRING', field.type);
    }
    static testMethod void createReferencedField_lavel5() {
        Field field = new Field('Account.ParentId.ParentId.ParentId.ParentId.ParentId.Name');
        System.assertEquals('Account', field.objectName);
        System.assertEquals('Name', field.name);
        System.assertEquals('account.parent.parent.parent.parent.parent.name', field.path);
        System.assertEquals('STRING', field.type);
    }

    static testMethod void checkCondition_SingleValue () {
        Field field = new Field('Account.Name');
        System.assertEquals(false, field.hasCondition());

        field.value = null;
        System.assertEquals(false, field.hasCondition());

        field.value = '';
        System.assertEquals(false, field.hasCondition());

        field.value = '   ';
        System.assertEquals(false, field.hasCondition());

        field.value = 'dummy';
        System.assertEquals(true, field.hasCondition());
    }
    static testMethod void checkCondition_RangedValue () {
        Field field = new Field('Account.NumberOfEmployees');
        System.assertEquals(false, field.hasCondition());

        field.minValue = null;
        field.maxValue = null;
        System.assertEquals(false, field.hasCondition());

        field.minValue = '';
        field.maxValue = '';
        System.assertEquals(false, field.hasCondition());

        field.minValue = ' ';
        field.maxValue = '  ';
        System.assertEquals(false, field.hasCondition());

        field.minValue = '0';
        field.maxValue = null;
        System.assertEquals(true, field.hasCondition());

        field.minValue = null;
        field.maxValue = '10';
        System.assertEquals(true, field.hasCondition());

        field.minValue = '0';
        field.maxValue = '10';
        System.assertEquals(true, field.hasCondition());
    }

    static testMethod void createWhereCondition_String () {
        Field field = new Field('Account.Name');
        field.value = 'CONDITION';
        System.assertEquals('account.name = \'CONDITION\'',  field.getWhereCondition());
    }
    static testMethod void createWhereCondition_StringWithWildcard () {
        Field field = new Field('Account.Name');
        field.value = '*CONDITION';
        System.assertEquals('account.name LIKE \'%CONDITION\'',  field.getWhereCondition());

        field.value = 'CONDITION*';
        System.assertEquals('account.name LIKE \'CONDITION%\'',  field.getWhereCondition());

        field.value = '*CONDITION*';
        System.assertEquals('account.name LIKE \'%CONDITION%\'',  field.getWhereCondition());
    }
    static testMethod void createWhereCondition_Range () {
        Field field = new Field('Account.NumberOfEmployees');
        field.minValue = '0';
        field.maxValue = '';
        System.assertEquals('account.numberofemployees >= 0.0',  field.getWhereCondition());

        field.minValue = '';
        field.maxValue = '10';
        System.assertEquals('account.numberofemployees <= 10.0',  field.getWhereCondition());

        field.minValue = '0';
        field.maxValue = '10';
        System.assertEquals('(account.numberofemployees >= 0.0 AND account.numberofemployees <= 10.0)',  field.getWhereCondition());

        field.minValue = '0.0';
        field.maxValue = '10.0';
        System.assertEquals('(account.numberofemployees >= 0.0 AND account.numberofemployees <= 10.0)',  field.getWhereCondition());
    }
    static testMethod void createWhereCondition_ID () {
        Field field = new Field('Account.Id');
        field.value = 'value';
        System.assertEquals('account.id = \'value\'',  field.getWhereCondition());
    }
    static testMethod void createWhereCondition_MULTIPICKLIST () {
        // NOT TESTABLE - There is no standard MultiPicklist field.
    }
    static testMethod void createWhereCondition_BOOLEAN () {
        Field field = new Field('Contact.DoNotCall');

        field.value = 'true';
        System.assertEquals('contact.donotcall = true',  field.getWhereCondition());

        field.value = 'TRUE';
        System.assertEquals('contact.donotcall = true',  field.getWhereCondition());

        field.value = 'TRue';
        System.assertEquals('contact.donotcall = true',  field.getWhereCondition());

        field.value = 'true ';
        System.assertEquals('contact.donotcall = true',  field.getWhereCondition());

        field.value = 'false';
        System.assertEquals('contact.donotcall = false',  field.getWhereCondition());
    }
}