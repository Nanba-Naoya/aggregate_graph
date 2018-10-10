import { Component, ViewChild, ElementRef } from '@angular/core';

import { Chart } from 'chart.js';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'frontend';

  @ViewChild('myChart') ref: ElementRef;

  context: CanvasRenderingContext2D;
  chart: Chart;

  ngOnInit() {
    this.context = (<HTMLCanvasElement>this.ref.nativeElement).getContext('2d');
    this.draw();
  }

  draw() {
    this.chart = new Chart(this.context, {
      type: 'bar',
      data: {
        labels: ['8/26','8/27','8/28','8/29','8/30','8/31','9/1'],
        datasets: [{
          label: '時間',
          data: [12, 19, 3, 17, 28, 24, 7]
        }]
      }
    });
  }
}