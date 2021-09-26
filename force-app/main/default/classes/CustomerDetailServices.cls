@RestResource(urlMapping='/customer/*')
global with sharing class CustomerDetailServices {
    @HttpGet
    global static CustomerWrapper doGet() {
        CustomerWrapper cwrap = new CustomerWrapper();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //Get customer unique identifier 
        String customerUid = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        try {
                //query customer details
                List<Contact> lstContact = [SELECT Id, LastName, FirstName,Product__c, Product__r.Name, Product__r.type__c,Product__r.Customer_ATM_Fee__c ,Product__r.Customer_cost_per_calendar_month__c,Product__r.CurrencyIsoCode,Product__r.Card_Replacement_Cost__c, Home_Country__c FROM Contact WHERE External_System_Id__c=:customerUid ];
                //No record exist based on the unique identifier
                if(lstContact.isEmpty()){
                    cwrap.isSuccess =false;
                    cwrap.errorMessage = 'Invalid customer id';
                }else{
                    Contact cDetails = lstContact[0];
                    cwrap.isSuccess = true;
                    cwrap.firstName = cDetails.FirstName;
                    cwrap.lastName = cDetails.LastName;
                    //There is no product associated with the customer
                    if(cDetails.Product__c == null){
                        cwrap.errorMessage = 'No Product is attached to the customer';
                    }else{
                        cwrap.replacementCost = cDetails.Product__r.Card_Replacement_Cost__c;
                        cwrap.accountMonthlyCost= cDetails.Product__r.Customer_cost_per_calendar_month__c;
                        cwrap.accountType = cDetails.Product__r.type__c;
                        cwrap.atmFee  = cDetails.Product__r.Customer_ATM_Fee__c;
                        cwrap.country  = cDetails.Home_Country__c;
                        cwrap.currencyType  = cDetails.Product__r.CurrencyIsoCode;
                    }
                }   
        } catch (Exception ex) {
            cwrap.isSuccess =false;
            cwrap.errorMessage = ex.getMessage();
        }
        return cwrap;
    }

    global class CustomerWrapper{
        //Are we get the customer details successfully?
        public Boolean isSuccess {get;set;}
        // Error message if record not found
        public String errorMessage {get;set;}
        //Customer First Name
        public String firstName {get;set;}
        //Customer Last Name
        public String lastName {get;set;}
        // Customer country
        public String country {get;set;}
        //Account's Cost per Calendar Month
        public String accountMonthlyCost {get;set;}
        //Account's ATM Fee
        public String atmFee {get;set;}
        //Type of Account
        public String accountType {get;set;}
        //Account's Card Replacement Cost
        public Decimal replacementCost {get;set;}
        //Currecy supported
        public String currencyType {get;set;}
    }
}
