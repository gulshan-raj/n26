import { LightningElement,api, track } from 'lwc';
import getCustomerDetails from '@salesforce/apex/CustomerKeyInfoController.populateCustomerDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CustomerKeyInfo extends LightningElement {
    @api recordId;
    @track productId;
    @track isLoaded;
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
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error occurs',
                        message: result.errorMessage,
                        variant: 'error'
                    })
                );
            }
            this.isLoaded = false;
        })
        .catch(error=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error occurs',
                    message: error.body.message,
                    variant: 'error'
                })
            );
            this.isLoaded = false;
        });
    }
}