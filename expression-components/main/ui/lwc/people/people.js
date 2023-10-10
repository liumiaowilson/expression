import TwElement from "c/twElement";
import evaluate from '@salesforce/apex/FormulaEvaluatorUiController.evaluate';
import { api, wire } from "lwc";
import { classNames } from 'c/utils';

export default class People extends TwElement {
  @api expr;

  computed;
  error;

  @wire(evaluate, {recordId: '', formula: '$expr'})
  evaluate({error, data}) {
    if (error) {
      console.error(error);
      this.error = error.body.message;
    } else {
      this.computed = data;
      this._validate();
    }
  }

  get hasText() {
    return this.computed?.title || this.computed?.description;
  }

  get loading() {
    return !this.computed && !this.error;
  }

  get hasError() {
    return this.error;
  }

  get ready() {
    return !this.loading && !this.hasError;
  }

  _validate() {
    if (!this.computed) {
      return;
    }
    // Computed should contain a "people" property.
    if (!("people" in this.computed)) {
      this.error = "Computed data does not contain a 'people' property.";
    }
  }
}
