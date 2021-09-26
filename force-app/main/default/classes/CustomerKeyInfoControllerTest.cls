@isTest
public class CustomerKeyInfoControllerTest {
    @TestSetup
    static void generateData(){
        Product__c p = TestDataFactory.getTestProduct('Standard','EUR','DE',1.7,6,0);
        Contact con = TestDataFactory.getTestContactWithProduct('Test','Contact','EUR','DE',p.Id,'123');
        Case c = TestDataFactory.getCase(con,'EUR');
    }

    @isTest
    static void testCustomerWithProductAttached(){
        Case c = [SELECT id FROM case];
        Product__c p = [SELECT id FROM Product__c];
        Test.startTest();
        CustomerKeyInfoController.CustomerKeyDetailsWrapper cwWrap = CustomerKeyInfoController.populateCustomerDetails(c.Id);
        system.assertEquals(cwWrap.productId, p.id);
        system.assertEquals(cwWrap.isSuccess, true);
        Test.stopTest();

    }

    @isTest
    static void testCustomerWithNoProductAttached(){
        Case c = [SELECT id FROM case];
        Contact con = [SELECT id,Product__c FROM contact];
        con.Product__c =  null;
        update con;
        Test.startTest();
        CustomerKeyInfoController.CustomerKeyDetailsWrapper cwWrap = CustomerKeyInfoController.populateCustomerDetails(c.Id);
        system.assert(cwWrap.productId == null);
        system.assertEquals(cwWrap.isSuccess, false);
        Test.stopTest();

    }
}
