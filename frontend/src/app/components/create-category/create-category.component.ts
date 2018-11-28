import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';

import { CreateCategoryService } from  '../services/create-category.service';
import { Category } from '../category';

@Component({
  selector: 'app-create-category',
  templateUrl: './create-category.component.html',
  styleUrls: ['./create-category.component.css'],
  providers: [CreateCategoryService]
})
export class CreateCategoryComponent implements OnInit {
  categories: Category;
  form: FormGroup;

  constructor(private CreateCategoryService: CreateCategoryService) { 
    this.form = new FormGroup({
      title: new FormControl(),
    });
  }

  ngOnInit() {
  }

  onCreate() {
    this.CreateCategoryService.createCategories(this.form.value).subscribe(response => {
      response = response;
    });
  }

}
