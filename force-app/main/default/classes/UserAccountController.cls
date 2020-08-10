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
       currentUser = [Select Username, Email, Firstname, Lastname, Name, ContactId From User Where Id = :UserInfo.getUserId()];
       contact = [Select Id, AccountId, Name, Phone, Email From Contact Where Id = :currentUser.ContactId];
       address = new Address__c();       
       List<Contact_Address__c> acList =  [Select Address__c From Contact_Address__c Where Contact__c = :contact.Id];
        
        List<ID> aListIds = new List<ID>();
        if(acList.size() > 0){
            for( Contact_Address__c ca: acList){
          		  aListIds.add(ca.Address__c);
        	}
        }
       
        addresses = (aListIds.size() > 0)?
            [Select Id, Name, Address_Line_1__c, Address_Line_2__c, City__c, Country__c, State__c, Postal_Zip_Code__c From Address__c Where Id in :aListIds]:
        	new List<Address__c>();
    	
        disabled = false;
        show = true;
        hide = false;
    }
   
    
    public void edit(){
         hide = !hide;
         show = !show;
    }

    public void save(){
        update currentUser;
       //if(this.addresses.size() > 0)
        update addresses;    
            
       hide = !hide;
        show = !show;
    }
    
    public void newAdd(){
        disabled = !disabled;
    }
    
    public void cancel(){
       hide = !hide;
        show = !show;
    }

  public void save2(){
        insert address;
        Contact_Address__c ca = new Contact_Address__c();
        ca.Name = contact.Name + '-' + address.Name;
        ca.Contact__c = contact.Id;
        ca.Address__c = address.Id;
        insert ca;
        disabled = !disabled;
    }
}