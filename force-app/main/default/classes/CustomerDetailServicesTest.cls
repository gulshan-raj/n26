@isTest
public class CustomerDetailServicesTest {
    @TestSetup
    static void generateData(){
        Product__c p = TestDataFactory.getTestProduct('Standard','EUR','DE',1.7,6,0);
        Contact con = TestDataFactory.getTestContactWithProduct('Test','Contact','EUR','DE',p.Id,'123');
    }

    @isTest
    static void testValidCustomerDetails(){
        Contact c = [SELECT Id, LastName, FirstName,Product__c, Product__r.Name, Product__r.type__c,Product__r.Customer_ATM_Fee__c ,Product__r.Customer_cost_per_calendar_month__c,Product__r.CurrencyIsoCode,Product__r.Card_Replacement_Cost__c, Home_Country__c FROM Contact WHERE External_System_Id__c='123'];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/customer/123'; 
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
        CustomerDetailServices.CustomerWrapper cwrapper = CustomerDetailServices.doGet();
        system.assertEquals(cwrapper.isSuccess, true );
        system.assertEquals(cwrapper.firstName, c.FirstName);
        system.assertEquals(cwrapper.lastName, c.LastName );
        system.assertEquals(cwrapper.country, c.Home_Country__c );
        system.assertEquals(cwrapper.accountMonthlyCost, c.Product__r.Customer_cost_per_calendar_month__c);
        system.assertEquals(cwrapper.atmFee, c.Product__r.Customer_ATM_Fee__c );
        system.assertEquals(cwrapper.accountType, c.Product__r.type__c );
        system.assertEquals(cwrapper.replacementCost,c.Product__r.Card_Replacement_Cost__c );
        system.assertEquals(cwrapper.currencyType, c.Product__r.CurrencyIsoCode );
        Test.stopTest();  
    }

    @isTest
    static void testInvalidCustomerDetails(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/customer/invalid'; 
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
        CustomerDetailServices.CustomerWrapper cwrapper = CustomerDetailServices.doGet();
        system.assertEquals(cwrapper.isSuccess, false );
        system.assertEquals(String.isBlank(cwrapper.errorMessage),true );
        Test.stopTest();  
    }

    @isTest
    static void testValidCustomerWithNoProductDetails(){
        Contact  c = [SELECT id,Product__c FROM Contact];
        c.Product__c = null;
        update c;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/customer/123'; 
        req.httpMethod = 'Get';
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
        CustomerDetailServices.CustomerWrapper cwrapper = CustomerDetailServices.doGet();
        system.assertEquals(cwrapper.isSuccess, true );
        system.assertEquals(String.isBlank(cwrapper.errorMessage),false );
        Test.stopTest();  
    }
}
