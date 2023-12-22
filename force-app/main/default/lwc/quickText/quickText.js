import { LightningElement,wire,track } from 'lwc';
import my_Resource from "@salesforce/resourceUrl/sms_Landing_Page_Image";
import registerAccount from '@salesforce/apex/QuickTextController.registerUpdateAccountCredentials';
import getAllAccountCredentials from '@salesforce/apex/QuickTextController.getAllAccountCredentials';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class QuickText extends LightningElement {
    landingPageImage = my_Resource;
    isRgisterAccount = false;
    loaded = true;
    credential={};
    options = [];
    wiredCredtList = [];
    @track value;

    @wire(getAllAccountCredentials) credList(result) {
        this.wiredCredtList = result;
    
        if (result.data) {
         let data = result.data;
         console.log('data>>>',data)
          let temp =[];
          data.forEach(element => {
                    temp.push({label:element.Name+'-'+element.SenderPhone__c, value:element.Id})
                });
          this.options = temp;
        } else if (result.error) {
            console.log('error>>>>',result.error);
          this.error = result.error;
        }
      }
    

    openCredentialRegistrationForm(){
        console.log('clicked:::')

        this.isRgisterAccount = true;
        console.log('isRgisterAccount:::',isRgisterAccount)
    }

    hideCredentialRegistrationForm(){
        this.isRgisterAccount = false;
        this.credential = {};
    }

    handleChange(event){
        if(event.target.name === 'Name'){
            this.credential.Name = event.target.value;

        }else if(event.target.name === 'AccountSid'){
            this.credential.AccountSid__c = event.target.value;

        }else if(event.target.name === 'Token'){
            this.credential.Token__c = event.target.value;

        }else if(event.target.name === 'RegisteredPhoneNumber'){
            this.credential.SenderPhone__c = event.target.value;

        }else if(event.target.name === 'Active'){
            this.credential.Active__c = event.target.value;

        }else if(event.target.name === 'SelectAccount'){
            this.value = event.target.value;
            console.log('combo value>>>',this.value);

        }
    }

    saveCredential(){
        console.log('credential>>>>>',JSON.stringify(this.credential));
        this.loaded = false;
        registerAccount({inputCred:this.credential})
        .then(result => {
            if(result){
                this.showToast('Success','','success')
                refreshApex(this.wiredCredtList);
                this.loaded = true;
                this.hideCredentialRegistrationForm();


            }
        })
        .catch(error => {
            this.error = error;
            this.showToast('Error',error.body.message,'error')

            console.log('error>>>>>>>',error);
        });
    }

        showToast(title,message,variant) {
            const event = new ShowToastEvent({
                title: title,
                message:message,
                variant:variant
            });
            this.dispatchEvent(event);
        }
}