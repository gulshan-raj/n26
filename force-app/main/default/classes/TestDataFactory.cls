@isTest
public class TestDataFactory {

    //Insert default test contact
    public static Contact getTestContact(){
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.currencyISOcode='EUR';
        insert c;
        return c;
    }
    //Insert test contact with specific details
    public static Contact getTestContactWithProduct(String firstName, String lastName, String currencyCode,String homeCountry, Id productId, String extId){
        Contact c = new Contact();
        c.FirstName = firstName;
        c.LastName = lastName;
        //populate default currencty if no currency passed to parameter
        c.currencyISOcode = String.isBlank(currencyCode) ? 'EUR' : currencyCode;
        c.Home_Country__c =  homeCountry;
        c.Product__c = productId;
        c.External_System_Id__c =  extId;
        insert c;
        return c;
    }

    //Generate product
    public static Product__c getTestProduct(String type, String currencyCode, String country, Decimal atmFee, Decimal cardReplaceCost, Decimal monthlyFee){
        Product__c p = new Product__c();
        p.Type__c = type;
        //populate default currencty if no currency passed to parameter
        p.CurrencyIsoCode = String.isBlank(currencyCode) ? 'EUR' : currencyCode;
        p.Country__c = country;
        p.ATM_Fee__c = atmFee;
        p.Card_Replacement_Cost__c = cardReplaceCost;
        p.Cost_per_Calendar_Month__c =  monthlyFee;
        insert p;
        return p;
    }

    //Generate Case
    public static Case getCase(Contact customer,String currencyCode){
        Case c = new Case();
        c.ContactID = customer.Id;
        //populate default currencty if no currency passed to parameter
        c.CurrencyISOcode = String.isBlank(currencyCode) ? 'EUR' : currencyCode;
        c.Origin = 'Web';
        insert c;
        return c;
    }
}
