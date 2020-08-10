/*
 * MailDataFactory
 *  Creates contacts, addresses, contact-addresses and mail for external users
 * 		Each contact has single contact-address, single address, random number of mail 1-10
 * 		Contacts can be from 1/11 following states: CA, NY, TX, FL, VA, AZ, AL, CO, GA, MD, HI
 * 			Created with default First Name: Contact x, Last Name: Test
 * 				Where x corresponds to the order contacts/addresses/contact-addresses were made
 * 				Max x = 30 to avoid governor limits
 * 		Addresses created with default name: Address x
 * 		Contact-Addresses created with default name: Contact-Address x
 * 		Mail will have any status: Not Processed, Information Received, Shipped, In Transit, Delivered, Lost
 * 			Random values for weight, height, width
 * 			No insurance values, to avoid triggering the automatic approval processes/process builder
 * 		
 * Execute:
 * 	MailDataFactory mdf = new MailDataFactory();
 * 	mdf.dataFactory(n);
 * 
 * 		Where n = number of new contacts made
 * */
public class MailDataFactory {
    
    // Main method for data factory
    public void dataFactory(Integer numCreate) {
        // Get current contacts
        Account externalAcc = [SELECT Name, Id FROM Account WHERE Name='External User\'s Account' LIMIT 1];
        List<Contact> associatedCon = [SELECT Name, Id FROM Contact WHERE AccountId = :externalAcc.Id];
        
    	// Insert new contacts
        List<Contact> newCon = createContact(numCreate, associatedCon.size(), externalAcc.Id);
        insert newCon;
        
        // Insert new addresses
        List<Address__c> newAddr = createAddr(numCreate, associatedCon.size());
        insert newAddr;
        
        // Insert new contact-addresses
        List<Contact_Address__c> newConAddr = createConAddr(numCreate, associatedCon.size(), newCon, newAddr);
        insert newConAddr;
        
        // Insert random number of mail per contact-address
        List<Mail__c> allMail = new List<Mail__c>();
        for(Contact_Address__c ca: newConAddr) {
            List<Mail__c> newMail = createMail();
            for(Mail__c m: newMail) {
                m.Contact_Address__c = ca.Id;
                allMail.add(m);
            }
        }
        System.debug(allMail);
        insert allMail;
    }
    
    // Creates new contacts, starting from current number, and returns contacts
    public List<Contact> createContact(Integer numCreate, Integer currNum, Id accId) {
        List<Contact> newContacts = new List<Contact>();
        
        for(Integer i=currNum+1; i<numCreate+currNum+1; i++) {
            Contact tempCon = new Contact();
            tempCon.FirstName = 'Contact ' + i;
            tempCon.LastName = 'Test';
            tempCon.AccountId = accId;
            
            newContacts.add(tempCon);
        }
        
        return newContacts;
    }
    
    // Creates new addresses and returns addresses
    public List<Address__c> createAddr(Integer numCreate, Integer currNum) {
        List<Address__c> newAddr = new List<Address__c>();
        // CA, NY, TX, FL, VA, AZ, AL, CO, GA, MD, HI
        
        for(Integer i=currNum+1; i<numCreate+currNum+1; i++) {
            Address__c tempAddr = new Address__c();
            
            Double randDouble = math.random();
            Long randLong = math.roundToLong(randDouble*10);
            
            tempAddr.Name = 'Address ' + i;
            tempAddr.Address_Line_1__c = i + ' Test St.';
            tempAddr.City__c = 'Test City';
            
            switch on randLong {
                when 0 {
                    tempAddr.State__c = 'CA';
                }
                when 1 {
                    tempAddr.State__c = 'NY';
                }
                when 2 {
                    tempAddr.State__c = 'TX';
                }
                when 3 {
                    tempAddr.State__c = 'FL';
                }
                when 4 {
                    tempAddr.State__c = 'VA';
                }
                when 5 {
                    tempAddr.State__c = 'AZ';
                }
                when 6 {
                    tempAddr.State__c = 'AL';
                }
                when 7 {
                    tempAddr.State__c = 'CO';
                }
                when 8 {
                    tempAddr.State__c = 'GA';
                }
                when 9 {
                    tempAddr.State__c = 'MD';
                }
                when 10 {
                    tempAddr.State__c = 'HI';
                }
            }
            
            newAddr.add(tempAddr);
        }
        
        return newAddr;
    }

    // Create new contact-addresses related to new contacts and new addresses
    public List<Contact_Address__c> createConAddr(Integer numCreate, Integer currNum, List<Contact> conList, List<Address__c> addrList) {
        List<Contact_Address__c> newConAddr = new List<Contact_Address__c>();
        
        for(Integer i=0; i<numCreate; i++) {
            Contact_Address__c tempConAddr = new Contact_Address__c();
            
            tempConAddr.Contact__c = conList.get(i).Id;
            tempConAddr.Address__c = addrList.get(i).Id;
            tempConAddr.Name = 'Contact-Address ' + (i+currNum+1);
            
            newConAddr.add(tempConAddr);
        }
        
        return newConAddr;
    }
    
    // Create random number of mail (1-5) with random status where lost has 4% rate
    public List<Mail__c> createMail() {
        List<Mail__c> newMail = new List<Mail__c>();     
        
		Integer numMail;
		Double randDouble = math.random();
        if(randDouble <= 0.20) {
            numMail = 1;
        } else if(randDouble <= 0.40) {
            numMail = 2;
        } else if(randDouble <= 0.60) {
            numMail = 3;
        } else if(randDouble <= 0.80) {
            numMail = 4;
        } else {
            numMail = 5;
        }
        
        for(Integer i=0; i<numMail; i++) {
            Mail__c tempMail = new Mail__c();
            
            randDouble = math.random();
            tempMail.Height__c = randDouble*10;
            randDouble = math.random();
            tempMail.Width__c = randDouble*10;
            randDouble = math.random();
            tempMail.Weight__c = randDouble*10;
            
            randDouble = math.random();        
            if(randDouble <= 0.15) {
                tempMail.Delivery_Status__c = 'Not Processed';
            } else if(randDouble <= 0.24) {
                tempMail.Delivery_Status__c = 'Information Received';
            } else if(randDouble <= 0.48) {
                tempMail.Delivery_Status__c = 'Shipped';
            } else if(randDouble <= 0.72) {
                tempMail.Delivery_Status__c = 'In Transit';
            } else if(randDouble <= 0.96) {
                tempMail.Delivery_Status__c = 'Delivered';
            } else {
                tempMail.Delivery_Status__c = 'Lost';
            }
            
            newMail.add(tempMail);
        }
		return newMail;        
    }
    
}