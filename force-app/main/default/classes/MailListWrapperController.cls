public with sharing class MailListWrapperController {
    public List<Wrapper> masterList {get; set;}
	public List<Wrapper> mailList {get; set;}
    public Mail__c sample {get; set;}
    
    // Create list of wrappers with necessary objects and fields
    public MailListWrapperController() {
        masterList = new List<Wrapper>();
        // Store necessary mail, contact_address, and address info
        for(Mail__c m: [SELECT Id, Delivery_Status__c, Contact_Address__c, Contact_Address__r.Address__c, 
                        Contact_Address__r.Address__r.Address_Line_1__c, Contact_Address__r.Address__r.Address_Line_2__c, 
                        Contact_Address__r.Address__r.City__c, Contact_Address__r.Address__r.Postal_Zip_Code__c, 
                        Contact_Address__r.Address__r.State__c FROM Mail__c]) {
            Wrapper temp = new Wrapper();
            temp.mail = m;
                            
            temp.conAddr = new Contact_Address__c();
            temp.conAddr.Id = m.Contact_Address__c;           
           
            temp.addr = new Address__c();
            temp.addr.Id = m.Contact_Address__r.Address__c;
            temp.addr.Address_Line_1__c = m.Contact_Address__r.Address__r.Address_Line_1__c;
            temp.addr.Address_Line_2__c = m.Contact_Address__r.Address__r.Address_Line_2__c;
            temp.addr.City__c = m.Contact_Address__r.Address__r.City__c;
			temp.addr.Postal_Zip_Code__c = m.Contact_Address__r.Address__r.Postal_Zip_Code__c;
            temp.addr.State__c = m.Contact_Address__r.Address__r.State__c;                
            
            masterList.add(temp);
        }       

        mailList = masterList.clone();
		sample = new Mail__c();        
    }
    
    public class Wrapper {
        public Mail__c mail {get; set;}
        public Contact_Address__c conAddr {get; set;}
        public Address__c addr {get; set;}
    }
    
    // Set mailList based on inputField sample
    public void Filter() {
        RefreshView();
        
        for(Integer i=(mailList.size()-1); i>=0; i--) {
            if(mailList.get(i).mail.Delivery_Status__c != sample.Delivery_Status__c) {
                mailList.remove(i);
            }
        }
    }
    
    // Filter based on mail currently shipping (information received, in transit, shipped)
    public void Shipping() {
        RefreshView();
        
        for(Integer i=(mailList.size()-1); i>=0; i--) {
            if(mailList.get(i).mail.Delivery_Status__c=='Lost' || mailList.get(i).mail.Delivery_Status__c=='Not Processed' || mailList.get(i).mail.Delivery_Status__c=='Delivered')
            {
                mailList.remove(i);
            }
        }
    }
    
    // Filter based on past deliveries (delivered and lost)
    public void Past() {
        RefreshView();
        
        for(Integer i=(mailList.size()-1); i>=0; i--) {
            if(mailList.get(i).mail.Delivery_Status__c!='Lost' && mailList.get(i).mail.Delivery_Status__c!='Delivered') {
                mailList.remove(i);
            }
        }
    }
    
    // Reset current view
    public void RefreshView() {
        mailList = masterList.clone();
    }

}