import { LightningElement,track } from 'lwc';

export default class Demo extends LightningElement {
    @track slideRight = false;

    get slideClass() {
      return `slide${this.slideRight ? ' slide-right' : ''}`;
    }

    handleSlideClick() {
      this.slideRight = !this.slideRight;
    }
}