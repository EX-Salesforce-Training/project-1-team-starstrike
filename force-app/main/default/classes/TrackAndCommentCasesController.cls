public with sharing class TrackAndCommentCasesController {
	
    public List<Wrapper> caseList {get; set;}
    public Boolean defaultButton {get; set;}
    
    public TrackAndCommentCasesController() {
        // Get necessary case fields and newest case comment
        caseList = new List<Wrapper>();
        for(Case c: [SELECT CaseNumber, Status, Reason, Description, Subject, Id, 
                     (SELECT CommentBody, LastModifiedDate FROM CaseComments ORDER BY LastModifiedDate DESC LIMIT 1) FROM Case] ) {
                         Wrapper temp = new Wrapper();
                         temp.cases = c;

                         if(c.CaseComments.isEmpty()) {
                             temp.comments = null;
                         } else {
                             CaseComment tempComment = c.CaseComments.get(0);
                             temp.comments = (String) tempComment.CommentBody;
                             System.debug(temp.comments);
                         }
                         
                         if(temp.cases.Status=='Closed') {
                             temp.editableComment = false;
                         } else {
                             temp.editableComment = true;
                         }
                         
                         temp.selectComment = false;
                         temp.newComment = new CaseComment();
                         caseList.add(temp);            
                     }
        defaultButton = true;
    }
    
    public class Wrapper {
        public Case cases {get; set;}
        public String comments {get; set;}
        public Boolean selectComment {get; set;}
        public Boolean editableComment {get; set;}
        public CaseComment newComment {get; set;}
    }
    
    public void commentButton() {
        defaultButton = false;
    }
    
    public void saveComment() {
        List<CaseComment> newComments = new List<CaseComment>();        
        for(Wrapper w: caseList) {
            if(w.selectComment==true) {
                CaseComment tempComment = new CaseComment();
                tempComment.ParentId = w.cases.Id;
                tempComment.CommentBody = w.newComment.CommentBody;
                tempComment.IsPublished = true;
                
                newComments.add(tempComment);
                w.selectComment = false;
            }
        }        
        insert newComments;
        defaultButton = true;
        
        List<Case> updatedCases = [SELECT CaseNumber, Status, Reason, Description, Subject, Id, 
                     (SELECT CommentBody, LastModifiedDate FROM CaseComments ORDER BY LastModifiedDate DESC LIMIT 1) FROM Case];
        for(Integer i=0; i<caseList.size(); i++) {
            caseList.get(i).cases = updatedCases.get(i);
            
			if(caseList.get(i).cases.CaseComments.isEmpty()) {
                caseList.get(i).comments = null;
            } else {
                CaseComment tempComment = caseList.get(i).cases.CaseComments.get(0);
                caseList.get(i).comments = (String) tempComment.CommentBody;
                System.debug(caseList.get(i).comments);
            }            
        }
            
    }
    
}