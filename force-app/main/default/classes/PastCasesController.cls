/////////////////////////////////////////////////////////////////
//
// Name: Project 1 Past Ticket(Case) View Controller
// Author: Ian Workman (ianjworkman@gmail.com)
// Date: 08/07/2020
// Description: Simple custom controller to filter show only 
// closed cases
//
/////////////////////////////////////////////////////////////////
//Record Level Security enforced with (with Sharing)
public with sharing class PastCasesController {
    public List<Case> caseRecords{get;set;}

    public PastCasesController() {
        caseRecords = [SELECT Id, Status, CaseNumber, Subject, Reason, Description FROM Case WHERE (Status = 'Closed')];
    }
}