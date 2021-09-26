import { LightningElement,api, track } from 'lwc';
import getCustomerDetails from '@salesforce/apex/CustomerKeyInfoController.populateCustomerDetails';
export default class CustomerKeyInfo extends LightningElement {
    @api recordId;
    @track productId;
    @track isLoaded;
    @track isError;
    @track errorMessage;
    @track fields;
    connectedCallback(){
        this.isLoaded = true;
        getCustomerDetails({caseId:this.recordId})
        .then(result =>{
            console.log('result',result);
            if(result.isSuccess){
                this.productId = result.productId;
                this.fields = result.productFields;
            }else{
                this.isError = true;
                this.errorMessage = result.errorMessage;
            }
            this.isLoaded = false;
        })
        .catch(error=>{
            this.isError = true;
            this.errorMessage = error;
            this.isLoaded = false;
        });
    }
}