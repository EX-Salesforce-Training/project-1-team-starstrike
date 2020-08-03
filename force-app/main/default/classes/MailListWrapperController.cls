public class MailListWrapperController {
	public List<Wrapper> mailList {get; set;}
    public Mail__c sample {get; set;}
    
    public MailListWrapperController() {
        mailList = new List<Wrapper>();
        for(Mail__c m: [SELECT Id, Delivery_Status__c, Contact_Address__c, Contact_Address__r.Address__c, 
                        Contact_Address__r.Address__r.Address_Line_1__c, Contact_Address__r.Address__r.Address_Line_2__c, 
                        Contact_Address__r.Address__r.City__c, Contact_Address__r.Address__r.Postal_Zip_Code__c, 
                        Contact_Address__r.Address__r.State__c FROM Mail__c]) {
            Wrapper temp = new Wrapper();
            temp.mail = m;
            temp.conAddr = new Contact_Address__c();
            temp.conAddr.Id = m.Contact_Address__c;           
            temp.currView = true;
            temp.addr = new Address__c();
            temp.addr.Id = m.Contact_Address__r.Address__c;
            temp.addr.Address_Line_1__c = m.Contact_Address__r.Address__r.Address_Line_1__c;
            temp.addr.Address_Line_2__c = m.Contact_Address__r.Address__r.Address_Line_2__c;
            temp.addr.City__c = m.Contact_Address__r.Address__r.City__c;
			temp.addr.Postal_Zip_Code__c = m.Contact_Address__r.Address__r.Postal_Zip_Code__c;
            temp.addr.State__c = m.Contact_Address__r.Address__r.State__c;                
                            
            
            mailList.add(temp);
        }       

		sample = new Mail__c();        
    }
    
    public class Wrapper {
        public Mail__c mail {get; set;}
        public Contact_Address__c conAddr {get; set;}
        public Address__c addr {get; set;}
        public boolean currView {get; set;}
    }
    
    public void filter() {
        refreshView();
        
        for(Wrapper w:mailList) {
            if(w.mail.Delivery_Status__c != sample.Delivery_Status__c) {
                w.currView = false;
            }
        }
    }
    
    public void refreshView() {
        for(Wrapper w:mailList) {
            w.currView = true;
        }
    }

}