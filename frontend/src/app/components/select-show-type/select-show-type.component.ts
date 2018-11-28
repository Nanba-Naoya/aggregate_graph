import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-select-show-type',
  templateUrl: './select-show-type.component.html',
  styleUrls: ['./select-show-type.component.css']
})
export class SelectShowTypeComponent implements OnInit {

  constructor() { }

  ngOnInit() {
    console.log(new Date().getFullYear())
    console.log(new Date().getMonth() + 1)
    console.log(new Date().getDate())
  }

}
