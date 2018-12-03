import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { ShowGraphService } from '../services/show-graph.service';

import { Category } from '../category';
import { WorkTime } from '../work_time';

@Component({
  selector: 'app-select-show-type',
  templateUrl: './select-show-type.component.html',
  styleUrls: ['./select-show-type.component.css'],
  providers: [ShowGraphService]
})
export class SelectShowTypeComponent implements OnInit {
  categories: Category;
  form: FormGroup;
  all_month = [1,2,3,4,5,6,7,8,9,10,11,12]
  yaer = new Date().getFullYear()
  max_day;
  all_day = [];
  month;
  day;
  category_id;
  graph_flag = false;
  category_flag = false;
  change = false;
  work_time;
  type_flag = false;

  constructor(private showGraphService: ShowGraphService) { 
    this.form = new FormGroup({
      category: new FormControl(),
      month: new FormControl(),
      day: new FormControl(),
    });
  }

  ngOnInit() {
    this.showGraphService.getCategories().subscribe((response) => {
      this.categories = response;
    })
  }

  onShowNomalgraph(){
    this.change = true;
  }

  onShowCategorygraph(){
    this.change = true;
  }

  onSelectCategory($event){
    this.category_id = $event.target.value
  }

  onChangegraph(){
    this.category_flag = false;
    this.graph_flag = true;
    this.type_flag = false;
  }

  onChangecategory(){
    this.graph_flag = false;
    this.category_flag = true;
    this.type_flag = true;
  }

  onChangeMonth($event){
    this.change = false;
    this.max_day = new Date(this.yaer, $event.target.value, 0).getDate()
    for (var i = 0; i < this.max_day; i++){
      this.all_day[i] = i + 1;
    }
    this.month = $event.target.value;
  }


  onChangeday($event){
    this.change = false;
    this.day = $event.target.value;
  }

}
