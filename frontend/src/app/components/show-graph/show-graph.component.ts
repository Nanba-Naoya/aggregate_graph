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
  @Input() month: [];
  @Input() day: [];
  title = 'frontend';
  category: Category;
  work_time: WorkTime;
  form: FormGroup;
  response;

  @ViewChild('myChart') ref: ElementRef;

  context: CanvasRenderingContext2D;
  chart: Chart;

  constructor(private showGraphService: ShowGraphService) { 
    this.form = new FormGroup({
      data: new FormControl()
    });
  }

  ngOnInit() {
    this.context = (<HTMLCanvasElement>this.ref.nativeElement).getContext('2d');
    this.showGraphService.getCategories().subscribe((response) => {
      this.category = response;
    })
   
    this.draw('pie');
  }

  getCategoryWorkTimes(){
    this.showGraphService.getCategories().subscribe((response) => {
      this.response = response;
    })
  }

  draw(a) {
    this.chart = new Chart(this.context, {
      type: a,
      data: {
        labels: ['a','b','c','d'],
        datasets: [{
          label: 'カテゴリ',
          data: [0.5, 4, 2.5, 1],
          backgroundColor:[
            "#2ecc71",
            "#3498db",
            "#95a5a6",
            "#9b59b6"
          ]
        }]
      }
    });
  }

}