import { Component, ViewChild, ElementRef } from '@angular/core';
import { Http } from '@angular/http';
import { Chart } from 'chart.js';

@Component({
  selector: 'app-show-graph',
  templateUrl: './show-graph.component.html',
  styleUrls: ['./show-graph.component.css']
})
export class ShowGraphComponent {
  title = 'frontend';
  categories;

  @ViewChild('myChart') ref: ElementRef;

  context: CanvasRenderingContext2D;
  chart: Chart;

  ngOnInit(http: Http) {

    this.context = (<HTMLCanvasElement>this.ref.nativeElement).getContext('2d');
    this.draw('pie');
  }

  draw(a) {
    this.chart = new Chart(this.context, {
      type: a,
      data: {
        labels: ['8/26','8/27','8/28','8/29'],
        datasets: [{
          label: 'æ™‚é–“',
          backgroundColor:[
            "#2ecc71",
            "#3498db",
            "#95a5a6",
            "#9b59b6"
          ],
          data: [0.5, 4, 2.5, 1]
        }]
      }
    });
  }
}