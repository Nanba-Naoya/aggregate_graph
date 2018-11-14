import { Component, ViewChild, ElementRef } from '@angular/core';

import { Chart } from 'chart.js';

@Component({
  selector: 'app-show-graph',
  templateUrl: './show-graph.component.html',
  styleUrls: ['./show-graph.component.css']
})
export class ShowGraphComponent {
  title = 'frontend';

  @ViewChild('myChart') ref: ElementRef;

  context: CanvasRenderingContext2D;
  chart: Chart;
  barNum = 6;
  labels = new Array(this.barNum);

  ngOnInit() {
    this.context = (<HTMLCanvasElement>this.ref.nativeElement).getContext('2d');
    this.draw('pie');
  }

  draw(a) {
    this.chart = new Chart(this.context, {
      type: a,
      data: {
        labels: ['8/26','8/27','8/28','8/29','8/30','8/31','9/1'],
        datasets: [{
          label: 'æ™‚é–“',
          backgroundColor:[
            "#2ecc71",
            "#3498db",
            "#95a5a6",
            "#9b59b6",
            "#f1c40f",
            "#e74c3c",
            "#34495e"
          ],
          data: [12, 19, 3, 17, 28, 24, 7]
        }]
      }
    });
  }
}