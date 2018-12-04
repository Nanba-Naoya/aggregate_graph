import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';

import { CreateCategoryService } from  '../services/create-category.service';
import { Category } from '../category';
import { validateForm } from '../../shared/functions/validate-form';

@Component({
  selector: 'app-create-category',
  templateUrl: './create-category.component.html',
  styleUrls: ['./create-category.component.css'],
  providers: [CreateCategoryService]
})
export class CreateCategoryComponent implements OnInit {
  categories: Category;
  form: FormGroup;
  formErrors: {[key: string]: Array<string>}= {};
  validationMessages = {
    'title': {
      'required': 'カテゴリを入力してください。',
    }
  };

  constructor(private CreateCategoryService: CreateCategoryService) { 
    this.form = new FormGroup({
      title: new FormControl(),
    });
  }

  ngOnInit() {
  }

  onSubmit() {
    if (this.form.valid) {
      this.formErrors =  validateForm(this.form, true, this.validationMessages);
      this.CreateCategoryService.createCategories(this.form.value).subscribe(response => {
        response = response;
      })
    } else {
      this.formErrors =  validateForm(this.form, false, this.validationMessages);
    }
  }

}
