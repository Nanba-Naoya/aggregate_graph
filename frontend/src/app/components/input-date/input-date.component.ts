import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';

import { InputDateService } from '../services/input-date.service';
import { Category } from '../category';
import { WorkTime } from '../work_time';
import { WorkTimesHour } from '../../shared/components/work_times_hour';
import { WorkTimesMinute } from '../../shared/components/work_times_minute';
;
@Component({
  selector: 'app-input-date',
  templateUrl: './input-date.component.html',
  styleUrls: ['./input-date.component.css'],
  providers: [InputDateService]
})

export class InputDateComponent implements OnInit {
  categories: Category;
  work_times: WorkTime;
  work_times_hour: WorkTimesHour;
  work_times_minute: WorkTimesMinute;
  form: FormGroup;

  constructor(private inputdateService: InputDateService) {
    this.form = new FormGroup({
      work_time: new FormControl(),
      hour: new FormControl(),
      minute: new FormControl()
    });
  }

  ngOnInit() {
    this.inputdateService.getCategories().subscribe((response) => {
      this.categories = response;
    })
    this.inputdateService.getWorkTimesHour().subscribe((response) => {
      this.work_times_hour = response;
    })
    this.inputdateService.getWorkTimesMinute().subscribe((response) => {
      this.work_times_minute = response;
    })
  }

  onCreate() {
    this.inputdateService.createWorkTimes(this.form.value).subscribe(response => {
      response = response;
    });
  }

  onChangeCategory($event){
    $event.target.value;
  }

  onChangeHour($event) {
    $event.target.value;
    
  }

  onChangeMinute($event){
    $event.target.value;
  }

}
