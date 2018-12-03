import { Component, ViewChild, ElementRef, Input } from '@angular/core';
import { Chart } from 'chart.js';

import { FormGroup, FormControl } from '@angular/forms';

import { ShowGraphService } from '../services/show-graph.service';
import { Category } from '../category';
import { WorkTime } from '../work_time';

@Component({
  selector: 'app-show-graph',
  templateUrl: './show-graph.component.html',
  styleUrls: ['./show-graph.component.css'],
  providers: [ShowGraphService]
})
export class ShowGraphComponent {
  @Input() month;
  @Input() day;
  @Input() type_flag;
  @Input() category_id;
  data;
  category: Category;
  work_time: WorkTime;
  response;
  date;
  form: FormGroup;
  error_flag = false;

  @ViewChild('myChart') ref: ElementRef;

  context: CanvasRenderingContext2D;
  chart: Chart;

  constructor(private showGraphService: ShowGraphService) { 
    this.form = new FormGroup({
      month: new FormControl(),
      day: new FormControl(),
      type_flag: new FormControl(),
      category_id: new FormControl(),
    });
  }

  ngOnInit() {
    this.form['month']  = this.month
    if (this.day !== undefined){
    this.form['day'] = this.day
    }

    if (this.category_id !== undefined){
    this.form['category_id'] = this.category_id
    }
    this.form['type_flag'] = this.type_flag
    this.context = (<HTMLCanvasElement>this.ref.nativeElement).getContext('2d');

    this.showGraphService.getCategories().subscribe((response) => {
      this.category = response;
    })
    this.showGraphService.getWorkTimes(this.form).subscribe((response) => {
      this.data = response;
      if (this.data['error']){
        this.error_flag = true;
      } else {
        this.draw('pie', this.getworktimes(this.data));
      }
    })
  }

  getworktimes(data){
    var category_name = [];
    var time = [];
    for(var work_time in data) {
      category_name.push(work_time)
      time.push(data[work_time]);
    }
    return [category_name,time]
  }

  draw(show_type,work_time) {
    this.chart = new Chart(this.context, {
      type: show_type,
      data: {
        labels: work_time[0],
        datasets: [{
          label: 'カテゴリ',
          data: work_time[1],
          /*backgroundColor:*/
        }]
      }
    });
  }

}