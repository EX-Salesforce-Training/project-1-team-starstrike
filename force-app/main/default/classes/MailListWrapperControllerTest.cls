@isTest
public class MailListWrapperControllerTest {
    
    @testSetup
    public static void TestSetupMethod() {
        // Create test contact
        Contact tempContact = new Contact();
        tempContact.FirstName = 'Jackson';
        tempContact.LastName = 'Smith';
        insert tempContact;
        
        // Create test address
        Address__c tempAddr = new Address__c();
        tempAddr.Name = 'Smith Address';
        tempAddr.Address_Line_1__c = '123 Test St.';
        tempAddr.City__c = 'Los Angeles';
        tempAddr.State__c = 'CA';
        insert tempAddr;
        
        // Create test contact_address and relate to created address and contact
        tempContact = [SELECT FirstName, LastName, Id FROM Contact WHERE (FirstName='Jackson' AND LastName='Smith') LIMIT 1];
        tempAddr = [SELECT Name, Id, Address_Line_1__c, City__c FROM Address__c WHERE (Address_Line_1__c='123 Test St.' AND City__c='Los Angeles') LIMIT 1];
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
    }

    @isTest
    public static void TestMailListWrapperControllerConstructor() {
        MailListWrapperController.Wrapper testWrapper = new MailListWrapperController.Wrapper();
        MailListWrapperController testController = new MailListWrapperController();
       
        for(MailListWrapperController.Wrapper w: testController.mailList) {
            if(w.addr.Address_Line_1__c=='123 Test St.') {
                testWrapper = w;
            }
        }
        
        //System.assertEquals(testWrapper.addr.Address_Line_1__c, '123 Test St.');
        System.assertEquals(testWrapper.addr.Address_Line_2__c, null);
        System.assertEquals(testWrapper.addr.City__c, 'Los Angeles');
        System.assertEquals(testWrapper.addr.Postal_Zip_Code__c, null);
        System.assertEquals(testWrapper.addr.State__c, 'CA');
    }
    
    @isTest
    public static void TestFilter() {
        MailListWrapperController testController = new MailListWrapperController();
        Mail__c testValidMail = new Mail__c();
        Mail__c testInvalidMail = new Mail__c();
        
        testController.sample.Delivery_Status__c = 'Lost';
        testController.mailList.get(0).mail.Delivery_Status__c = 'Lost';
        testController.mailList.get(1).mail.Delivery_Status__c = 'Shipped';
        testController.mailList.get(2).mail.Delivery_Status__c = 'Lost';
        testValidMail = testController.mailList.get(0).mail;
        testInvalidMail = testController.mailList.get(1).mail;
        
        testController.Filter();
        System.assertEquals(testValidMail, testController.mailList.get(0).mail);
        System.assertNotEquals(testInvalidMail, testController.mailList.get(1).mail);
    }
    
    @isTest
    public static void TestShipping() {
        MailListWrapperController testController = new MailListWrapperController();
        Mail__c testValidMail = new Mail__c();
        Mail__c testInvalidMail = new Mail__c();
        
        testController.mailList.get(0).mail.Delivery_Status__c = 'In Transit';
        testController.mailList.get(1).mail.Delivery_Status__c = 'Delivered';
        testController.mailList.get(2).mail.Delivery_Status__c = 'Shipped';
        testValidMail = testController.mailList.get(0).mail;
        testInvalidMail = testController.mailList.get(1).mail;
        
        testController.Shipping();
        System.assertEquals(testValidMail, testController.mailList.get(0).mail);
        System.assertNotEquals(testInvalidMail, testController.mailList.get(1).mail);
    }
    
    @isTest
    public static void TestPast() {
        MailListWrapperController testController = new MailListWrapperController();
        Mail__c testValidMail = new Mail__c();
        Mail__c testInvalidMail = new Mail__c();
        
        testController.mailList.get(0).mail.Delivery_Status__c = 'Delivered';
        testController.mailList.get(1).mail.Delivery_Status__c = 'Shipped';
        testController.mailList.get(2).mail.Delivery_Status__c = 'Lost';
        testValidMail = testController.mailList.get(0).mail;
        testInvalidMail = testController.mailList.get(1).mail;
        
        testController.Past();
        System.assertEquals(testValidMail, testController.mailList.get(0).mail);
        System.assertNotEquals(testInvalidMail, testController.mailList.get(1).mail);
    }
    
    @isTest
    public static void TestRefreshView() {
        MailListWrapperController testController = new MailListWrapperController();                
        testController.mailList.remove(0);
        
        testController.RefreshView();
        System.assertEquals(testController.masterList, testController.mailList);
    }
        
}