import { Component, OnInit } from '@angular/core';
import { Http } from '@angular/http';

@Component({
  selector: 'app-top-menu',
  templateUrl: './top-menu.component.html',
  styleUrls: ['./top-menu.component.css']
})
export class TopMenuComponent implements OnInit {
  comments;

  ngOnInit() {
  }

  constructor(http: Http){
    http.get('http://localhost:3000/api/v1/work_times')
    .subscribe(res => this.comments = res.json());
  }

}