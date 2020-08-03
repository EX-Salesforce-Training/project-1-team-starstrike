// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Mail__ChangeEvent {
    global Id Id;
    global String ReplayId;
    global Object ChangeEventHeader;
    global SObject Owner;
    global Id OwnerId;
    global String Name;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    /* Height of package in inches
    */
    global Double Height__c;
    /* Weight of package in pounds.
    */
    global Double Weight__c;
    /* Width of package in inches.
    */
    global Double Width__c;
    global String Delivery_Status__c;
    global Contact_Address__c Contact_Address__c;

    global Mail__ChangeEvent () 
    {
    }
}