public class TrackingCodeController {
    public Mail__c trackMail {get; set;}
    public String mailCode {get; set;}
    public String searchMessage {get; set;}
    public Boolean showFields {get; set;}
    public Boolean showMessage {get; set;}
    
    public TrackingCodeController() {
        //trackMail = new Mail__c();
        showFields = false;
        showMessage = false;
    }
    
    public void SearchCode() {
		// Reset values
		showFields = false;
        showMessage = false;
        
        if(mailCode.length() != 15) {
            searchMessage = 'Error: Enter valid tracking code';
            showMessage = true;
        }
        
        for(Mail__c m:[SELECT Name, Id, Delivery_Status__c, Height__c, Weight__c, Width__c, Contact_Address__c, Contact_Address__r.Address__c, 
                   Contact_Address__r.Address__r.Address_Line_1__c, Contact_Address__r.Address__r.Address_Line_2__c, 
                   Contact_Address__r.Address__r.City__c, Contact_Address__r.Address__r.Postal_Zip_Code__c, 
                   Contact_Address__r.Address__r.State__c FROM Mail__c]) {
            // Only take 15 digit Id
            String strId = Id.valueOf(m.Id); 
            strId = strId.substring(0,15);

            if(strId == mailCode) {
                trackMail = m;
                showFields = true;
                showMessage = false;
            }
        }
        
        if(showFields == false && showMessage == false) {
            searchMessage = 'No package not found';
            showMessage = true;
        }
    }
}