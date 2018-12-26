import { Component, OnInit } from '@angular/core';

import { ShowGraphService } from '../services/show-graph.service'
import { Category } from '../category';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-show-normal-graph',
  templateUrl: './show-normal-graph.component.html',
  styleUrls: ['./show-normal-graph.component.css']
})
export class ShowNormalGraphComponent implements OnInit {
  form: FormGroup
  categories: Category;
  month;
  day;
  category_flag = false;
  change = false;
  type_flag = false;
  data;
  eventData;

  constructor(private showGraphService: ShowGraphService) {
    this.form = new FormGroup({
      month: new FormControl(),
      day: new FormControl(),
      type_flag: new FormControl(),
    });
   }

  ngOnInit() {
  }

  onReceiveMonth(eventData) {
    if (eventData !== null){
      this.change = false
      this.month = eventData
      this.form['month'] = eventData
    }
  }

  onReceiveDay(eventData) {
      this.change = false
      this.day = eventData;
      this.form['day'] = eventData
  }

  onShowGraph(){
    this.form['type_flag'] = false
    if (this.form['month'] !== undefined){
      this.showGraphService.getWorkTimes(this.form).subscribe((response) => {
        this.data = response;
        if (this.data['error']){
          alert('データが見つかりません。')
        } else {
          this.change = true
        }
      })
    }
  }

}
