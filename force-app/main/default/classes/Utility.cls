public with sharing class Utility {
    public static Boolean isValidSalesforceId( String sfdcId, System.Type t ){
        try {
 
            if ( Pattern.compile( '[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}' ).matcher( sfdcId ).matches() ){
                // Try to assign it to an Id before checking the type
                Id tempid = sfdcId;
 
                // Use the Type to construct an instance of this sObject
                sObject sObj = (sObject) t.newInstance();
      
                // Set the ID of the new object to the value to test
                sObj.Id = tempid;

                return true;
            }
        } catch ( Exception e ){
            return false;
        }
 
        // ID is not valid
        return false;
    }
}
