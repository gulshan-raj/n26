public with sharing class CustomerKeyInfoController {
    
    @AuraEnabled(cacheable=true)
    public static CustomerKeyDetailsWrapper populateCustomerDetails(String caseId){
        CustomerKeyDetailsWrapper ckdWrapper = new CustomerKeyDetailsWrapper();
        ckdWrapper.isSuccess = true;
        //get fields from fieldset
        getFieldsFromFieldSet(ckdWrapper);
        //get associated product id
        populateProduct(caseId,ckdWrapper);

        system.debug('@@cdkWrapper: '+ckdWrapper);
        return ckdWrapper;

    }

    private static void getFieldsFromFieldSet(CustomerKeyDetailsWrapper ckdWrapper){
        List<Schema.FieldSetMember>  lstKeyDetails = SObjectType.Product__c.FieldSets.Customer_key_details.getFields();
        if(lstKeyDetails.isEmpty()){
            ckdWrapper.isSuccess = false;
            ckdWrapper.errorMessage = 'Error occurs. Please contact your administrator';
            return ;
        }
        List<String> fields = new List<String>();
        for( Schema.FieldSetMember f: lstKeyDetails){
            fields.add(f.getFieldPath());
        }
        ckdWrapper.productFields = fields;
    }

    private static void populateProduct(String caseId, CustomerKeyDetailsWrapper ckdWrapper){
        Case cs = [SELECT contact.product__c FROM case WHERE id=:caseId];
        if(cs.contact.product__c == null){
            ckdWrapper.isSuccess = false;
            ckdWrapper.errorMessage = 'No product is associated with the customer';
            return;
        }
        ckdWrapper.productId = cs.contact.product__c;
    }

    public class CustomerKeyDetailsWrapper{
        @AuraEnabled
        public Id productId {get;set;}
        @AuraEnabled
        public List<String> productFields {get;set;}
        @AuraEnabled
        public Boolean isSuccess {get;set;}
        @AuraEnabled
        public String errorMessage {get;set;}
    }
}
