public class UserAccountController {

    public User currentUser{get;set;}
    public Account account{get;set;}
    public Contact contact{get;set;}
    public List<Address__c> addresses{get;set;}
    public Address__c address{get;set;}
    
    public Boolean disabled{get;set;}
    public Boolean show{get;set;}
    public Boolean hide{get;set;}
    
    public UserAccountController(){
        this.currentUser = [Select Username, Email, Firstname, Lastname, Name, ContactId From User Where Id = :UserInfo.getUserId()];
        this.contact = (this.currentUser.ContactId != null)? 
            [Select Id, AccountId, Name, Phone, Email From Contact Where Id = :this.currentUser.ContactId]
            :new Contact();
       this.address = new Address__c();
       this.account = (this.contact.AccountId != null)? [Select Name From Account Where Id = :this.contact.AccountId] : new Account();
               
       List<Contact_Address__c> acList = (this.contact.Name == null)? 
           [Select Address__r.Id From Contact_Address__c Where Contact__r.Id = :this.contact.Id]
           : new List<Contact_Address__c>();
        
        List<String> aListIds = new List<String>();
        if(acList.size() > 0){
            for( Contact_Address__c ca: acList){
          		  aListIds.add(ca.Address__r.Id);
        	}
        }
       
        this.addresses = (aListIds.size() > 0)?
            [Select Name, Address_Line_1__c, Address_Line_2__c, City__c, Country__c, State__c, Postal_Zip_Code__c From Address__c Where Id in :aListIds]:
        	new List<Address__c>();
    	
        this.disabled = false;
        this.show = true;
        this.hide = false;
    }
   
    
    public void edit(){
         this.hide = !this.hide;
         this.show = !this.show;
    }

    public void save(){
        update this.currentUser;
        if(this.addresses.size() > 0)
            update this.addresses;    
            
        this.hide = !this.hide;
        this.show = !this.show;
    }
    
    public void newAdd(){
        this.disabled = !this.disabled;
    }
    
    public void cancel(){
       this.hide = !this.hide;
        this.show = !this.show;
    }

  public void save2(){
        if (this.contact.Id != null) {
            if(this.address.Name != null){
                this.addresses.add(this.address);
                insert this.address;
                Contact_Address__c ca = new Contact_Address__c();
                ca.Name = this.contact.Name + '-' + this.address.Name;
                ca.Contact__c = this.contact.Id;
                ca.Address__c = this.address.Id;
                insert ca;
                this.disabled = !this.disabled;
            } 
        }       
    }
}