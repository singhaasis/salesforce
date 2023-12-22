import { LightningElement,track } from 'lwc';
import getTopHeadlines from '@salesforce/apex/NewsRestApiController.getTopHeadlines';

export default class NewsRoom extends LightningElement {
    country;
    loaded = true;
    @track articles=[];
    changeHandler(e){
        this.country = e.target.value
        console.log('this.country>>',this.country);
    }

    fetchHeadlines(){
        this.loaded=false;
        getTopHeadlines({countryCode:this.country})
            .then(result => {
                console.log('result>>',result)
                this.articles = result.articles;
                this.loaded = true;

            })
            .catch(error => {
                this.error = error;
                this.loaded = true;
            });
    }
}