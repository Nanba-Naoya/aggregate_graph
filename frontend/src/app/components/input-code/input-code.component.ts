import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { CookieService } from 'ngx-cookie-service';

import { validateForm } from '../../shared/functions/validate-form';

@Component({
  selector: 'app-input-code',
  templateUrl: './input-code.component.html',
  styleUrls: ['./input-code.component.css']
})
export class InputCodeComponent implements OnInit {
  form: FormGroup;
  formErrors: {[key: string]: Array<string>}= {};
  validationMessages = {
    'title': {
      'required': 'code以下を入力してください。',
    }
  };

  constructor(private cookieService: CookieService) { 
    this.form = new FormGroup({
      code: new FormControl(),
    });
  }

  ngOnInit() {
  }

  onSubmit() {
    if(this.form.value['code'] !== ''){
    this.cookieService.set('code', this.form.value['code'])
    }
  }

}
