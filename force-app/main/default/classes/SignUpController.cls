/////////////////////////////////////////////////////////////////
//
// Name: Project 1 Sign Up Controller
// Author: Ian Workman (ianjworkman@gmail.com)
// Date: 08/05/2020
// Description: The Controller for the Sign up process of
// New Community users into our Salesforce Org.
//
/////////////////////////////////////////////////////////////////
public class SignUpController {
    public User nu {get;set;}
    public Account na {get;set;}
    
    //set up a new user, account, and contact for new sign up
    public SignUpController(){
        nu = new User();
        na = new Account();
        nu.ProfileId = '00e3t000001lCdJAAU';
        na.RecordTypeId = '0123t000000RnGyAAK';
    }
    
    //Page navigation methods
    public pagereference P1Next(){
        return page.SignUpPage2;
    }
    public pagereference P2Previous(){
        return page.SignUpPage1;
    }
    public pagereference SaveUserAcc(){
        return page.CommunitiesLogin;
    }
    
}