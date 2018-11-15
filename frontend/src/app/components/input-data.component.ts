import { Component, OnInit } from '@angular/core';
import { Http } from '@angular/http';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-input-data',
  templateUrl: './input-data.component.html',
  styleUrls: ['./input-data.component.css']
})
export class InputDataComponent implements OnInit {
  categories;
  worktimes;
  workcategories;

  ngOnInit() {
  }

  constructor(private http: Http){
    this.http.get('http://localhost:3000/api/v1/categories')
    .subscribe(res => this.categories = res.json());
  }

  onShow(http: Http){
    http.get('http://localhost:3000/api/v1/work_times')
    .subscribe(res => this.worktimes = res.json());
  }

  onSave(http: Http){
    http.post('http://localhost:3000/api/v1/categories',{})
    .subscribe(res => this.workcategories = res.json())
  }

}