public with sharing class CreateTicketController {

    public Case newCase {get; set;}
    public List<SelectOption> tList {get; set;}
    public List<SelectOption> rList {get; set;}
    public List<SelectOption> pList {get; set;}

    public CreateTicketController() {
        User usLogged = [Select ContactId From User Where Id = :UserInfo.getUserId()];
        System.debug(usLogged);
        Contact cont = (usLogged.ContactId != null )? [Select Id, AccountId From Contact Where Id = :usLogged.ContactId] : null;
        this.newCase = new Case();
        this.newCase.Origin = 'Web';
        this.newCase.Status = 'New';
        if(cont != null){
            this.newCase.Contact = cont;
            this.newCase.Account = cont.Account;            
        }
        
        try{
           	tList = new List<SelectOption>();
            tList.add(new SelectOption('','--None--'));
            rList = new List<SelectOption>();
            rList.add(new SelectOption('','--None--'));
            pList = new List<SelectOption>();
            pList.add(new SelectOption('','--None--'));
            
            Schema.DescribeFieldResult tResult = Case.Type.getDescribe();
            List<Schema.PicklistEntry> aux = tResult.getPicklistValues();
            for(Schema.PicklistEntry e: aux){
                SelectOption op = new SelectOption(e.getValue(),e.getLabel());
                tList.add(op);
            }
            
            Schema.DescribeFieldResult rResult = Case.Reason.getDescribe();
            List<Schema.PicklistEntry> aux1 = rResult.getPicklistValues();
            System.debug(aux1);
            for (Schema.PicklistEntry e : aux1) {
                SelectOption op = new SelectOption(e.getValue(),e.getLabel());
                rList.add(op);
            }
            Schema.DescribeFieldResult pResult = Case.Priority.getDescribe();
            List<Schema.PicklistEntry> aux2 = pResult.getPicklistValues();
            System.debug(aux2);
            for (Schema.PicklistEntry e : aux2) {
                SelectOption op = new SelectOption(e.getValue(),e.getLabel());
                pList.add(op);
            }
       }catch(System.NullPointerException e){}
        
        
    }

    public void submit(){
        if(!this.newCase.Subject.equals('') && !this.newCase.Description.equals('')){
            insert this.newCase;
        }
    }
}