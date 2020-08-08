public with sharing class CreateTicketController {

    public Case newCase {get; set;}
    public List<SelectOption> tList {get; set;}
    public List<SelectOption> rList {get; set;}
    public List<SelectOption> pList {get; set;}

    public CreateTicketController() {
        User usLogged = [Select ContactId From User Where Id = :UserInfo.getUserId()];
        Contact cont = (usLogged.ContactId != null )? [Select Id, AccountId From Contact Where Id = :usLogged.ContactId] : null;
        this.newCase = new Case();
        this.newCase.Origin = 'Web';
        if(cont != null){
            this.newCase.Contact = cont;
            this.newCase.Account = cont.Account;            
        }
        Schema.DescribeFieldResult tResult = Case.Type.getDescribe();
        for (Schema.PicklistEntry var : tResult.getPicklistValues()) {
            tList.add(new SelectOption(var.getValue(),var.getValue()));
        }
        Schema.DescribeFieldResult rResult = Case.Reason.getDescribe();
        for (Schema.PicklistEntry var : rResult.getPicklistValues()) {
            rList.add(new SelectOption(var.getValue(),var.getValue()));
        }
        Schema.DescribeFieldResult pResult = Case.Priority.getDescribe();
        for (Schema.PicklistEntry var : pResult.getPicklistValues()) {
            pList.add(new SelectOption(var.getValue(),var.getValue()));
        }
    }

    // public Case getContact(){
    //     return (this.newCase.ContactId.equals(''))? [Select ContactId from Case Limit 1] : [Select ContactId from Case Where ContactId = :this.newCase.ContactId];
    // }
}