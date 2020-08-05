@isTest
public class TrackingCodeControllerTest { 

    @testSetup
    public static void TestSetupMethod() {
        // Create test contact
        Contact tempContact = new Contact();
        tempContact.FirstName = 'Matthew';
        tempContact.LastName = 'Case';
        insert tempContact;
        
        // Create test address
        Address__c tempAddr = new Address__c();
        tempAddr.Name = 'Case Address';
        tempAddr.Address_Line_1__c = '12 Ripper St.';
        tempAddr.City__c = 'London';
        tempAddr.State__c = 'NY';
        insert tempAddr;
        
        // Create test contact_address and relate to created address and contact
        tempContact = [SELECT FirstName, LastName, Id FROM Contact WHERE (FirstName='Matthew' AND LastName='Case') LIMIT 1];
        tempAddr = [SELECT Name, Id, Address_Line_1__c, City__c FROM Address__c WHERE (Address_Line_1__c='12 Ripper St.' AND City__c='London') LIMIT 1];
        Contact_Address__c tempConAddr = new Contact_Address__c();
        tempConAddr.Contact__c = tempContact.Id;
        tempConAddr.Address__c = tempAddr.Id;
        insert tempConAddr;
        
        // Store created contact_address
        List<Contact_Address__c> tempConAddrList = [SELECT Id, Contact__r.Id, Address__r.Id FROM Contact_Address__c];
        for(Contact_Address__c ca: tempConAddrList) {
            if(ca.Contact__r.Id==tempContact.Id && ca.Address__r.Id==tempAddr.Id) {
                tempConAddr = ca;
            }
        }

        // Create test mail and relate to created contact_address
        List<Mail__c> newMail = new List<Mail__c>();
        Mail__c tempMail1 = new Mail__c();
        tempMail1.Contact_Address__c = tempConAddr.Id;
        tempMail1.Delivery_Status__c = 'Lost';
        
        Mail__c tempMail2 = new Mail__c();
        tempMail2.Contact_Address__c = tempConAddr.Id;
        tempMail2.Delivery_Status__c = 'Delivered';
        
        Mail__c tempMail3 = new Mail__c();
        tempMail3.Contact_Address__c = tempConAddr.Id;
        tempMail3.Delivery_Status__c = 'In Transit';
        
        newMail.add(tempMail1);
        newMail.add(tempMail2);
        newMail.add(tempMail3);
        insert newMail;
        
        /*createdMail = [SELECT Name, Id, Delivery_Status__c, Height__c, Weight__c, Width__c, Contact_Address__c, Contact_Address__r.Address__c, 
                      Contact_Address__r.Address__r.Address_Line_1__c, Contact_Address__r.Address__r.Address_Line_2__c, 
                      Contact_Address__r.Address__r.City__c, Contact_Address__r.Address__r.Postal_Zip_Code__c, 
                      Contact_Address__r.Address__r.State__c FROM Mail__c
                      WHERE (Contact_Address__r.Address__r.Address_Line_1__c='12 Ripper St.' AND Contact_Address__r.Address__r.City__c='London')];*/
    }
    
    @isTest
    public static void TestTrackingCodeControllerConstructor() {
        TrackingCodeController testController = new TrackingCodeController();
        System.assert(!testController.showFields);
        System.assert(!testController.showMessage);
    }
    
    @isTest
    public static void TestSearchCode() {
        TrackingCodeController testController = new TrackingCodeController();
        
        // Input invalid tracking code
        testController.mailCode = 'asdfasdf';
        testController.SearchCode();
        System.assert(!testController.showFields);
        System.assert(testController.showMessage);
        System.assertEquals('Error: Enter valid tracking code', testController.searchMessage);
        
        // Check valid tracking code
        List<Mail__c> createdMail = [SELECT Name, Id, Delivery_Status__c, Height__c, Weight__c, Width__c, Contact_Address__c, Contact_Address__r.Address__c, 
                      Contact_Address__r.Address__r.Address_Line_1__c, Contact_Address__r.Address__r.Address_Line_2__c, 
                      Contact_Address__r.Address__r.City__c, Contact_Address__r.Address__r.Postal_Zip_Code__c, 
                      Contact_Address__r.Address__r.State__c FROM Mail__c
                      WHERE (Contact_Address__r.Address__r.Address_Line_1__c='12 Ripper St.' AND Contact_Address__r.Address__r.City__c='London')];        
        Mail__c testMail = createdMail.get(0);
        String testId = Id.valueOf(testMail.Id);
        testId = testId.substring(0,15);
        
        testController.mailCode = testId;
        testController.SearchCode();
        System.assert(testController.showFields);
        System.assert(!testController.showMessage);
        
        testController.mailCode = '123456789012345';
        testController.SearchCode();
        System.assert(!testController.showFields);
        System.assert(testController.showMessage);
        System.assertEquals('No package found', testController.searchMessage);
    }
    
}