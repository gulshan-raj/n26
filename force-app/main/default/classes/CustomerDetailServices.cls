@RestResource(urlMapping='/customer/*')
global with sharing class CustomerDetailServices {
    @HttpGet
    global static CustomerWrapper doGet() {
        CustomerWrapper cwrap = new CustomerWrapper();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String customerUid = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        try {
            if(Utility.isValidSalesforceId(customerUid,Contact.class)){
                Contact cDetails = [SELECT Id, LastName, FirstName, Product__r.Name, Product__r.type__c,Product__r.Customer_ATM_Fee__c ,Product__r.Customer_cost_per_calendar_month__c,Product__r.CurrencyIsoCode,Product__r.Card_Replacement_Cost__c, Home_Country__c FROM Contact WHERE id=:customerUid ];
                cwrap.isSuccess = true;
                cwrap.firstName = cDetails.FirstName;
                cwrap.lastName = cDetails.LastName;
                cwrap.replacementCost = cDetails.Product__r.Card_Replacement_Cost__c;
                cwrap.accountMonthlyCost= cDetails.Product__r.Customer_cost_per_calendar_month__c;
                cwrap.accountType = cDetails.Product__r.type__c;
                cwrap.atmFee  = cDetails.Product__r.Customer_ATM_Fee__c;
                cwrap.country  = cDetails.Home_Country__c;
                cwrap.currencyType  = cDetails.Product__r.CurrencyIsoCode;
                
            }else{
                cwrap.isSuccess =false;
                cwrap.errorMessage = 'Invalid customer id';
            }
        } catch (Exception ex) {
            cwrap.isSuccess =false;
            cwrap.errorMessage = ex.getMessage();
        }
        return cwrap;
    }

    global class CustomerWrapper{
        public Boolean isSuccess {get;set;}
        public String errorMessage {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String country {get;set;}
        public String accountMonthlyCost {get;set;}
        public String atmFee {get;set;}
        public String accountType {get;set;}
        public Decimal replacementCost {get;set;}
        public String currencyType {get;set;}
    }
}
