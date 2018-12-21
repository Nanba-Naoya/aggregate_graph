import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { CookieService } from 'ngx-cookie-service';

import { InputDateService } from '../services/input-date.service';
import { Category } from '../category';
import { WorkTime } from '../work_time';
import { WorkTimesHour } from '../../shared/components/work_times_hour';
import { WorkTimesMinute } from '../../shared/components/work_times_minute';
import { environment } from '../../../environments/environment'

@Component({
  selector: 'app-input-date',
  templateUrl: './input-date.component.html',
  styleUrls: ['./input-date.component.css'],
  providers: [InputDateService]
})

export class InputDateComponent implements OnInit {
  googleUrl = environment.googleUrl;
  categories: Category;
  work_times: WorkTime;
  work_times_hour: WorkTimesHour;
  work_times_minute: WorkTimesMinute;
  form: FormGroup;
  change = false;
  all_month = [1,2,3,4,5,6,7,8,9,10,11,12]
  max_day;
  year = new Date().getFullYear()
  all_day = [];
  month;
  day;
  unselectCategory = true;
  unselectMonth = true;
  unselectDay = true;
  unselectHour = true;
  unselectMinute = true;
  isError = false;
  access = false;
  google_data;

  constructor(private inputdateService: InputDateService,
              private route: ActivatedRoute,
              private cookieService: CookieService) {
    this.form = new FormGroup({
      work_time: new FormControl(),
      hour: new FormControl(),
      minute: new FormControl(),
      month: new FormControl(),
      day: new FormControl(),
    });
  }

  ngOnInit() {
    /*クエリが取れていたら*/
    if (this.route.snapshot.queryParams['error'] !== 'access_denied'){
      this.google_data = this.route.snapshot.queryParams['code'];
      /*code以下を使ってgoogleカレンダー認証*/
      if(this.google_data !== undefined && this.cookieService.get('user_id') == ''){
        /*code以下がある、かつcookieがない場合のみとってくる*/
        this.inputdateService.getGoogleCalendar(this.google_data).subscribe((response) => {
          response = response;
          if (this.cookieService.get('user_id') !== response['cookie']){
            this.cookieService.set('user_id', response['cookie'])
          }
        })
      } else {
        if (this.cookieService.get('user_id') == ''){
          window.location.href = this.googleUrl
        }
      }
      this.inputdateService.getCategories(this.cookieService.get('user_id')).subscribe((response) => {
        this.categories = response;
      })
      this.inputdateService.getWorkTimesHour().subscribe((response) => {
        this.work_times_hour = response;
      })
      this.inputdateService.getWorkTimesMinute().subscribe((response) => {
        this.work_times_minute = response;
      })
      this.access = true;
    } else {
      this.access = false;
    }
  }

  google_calendar(){
    this.inputdateService.getGoogleCalendar(this.google_data).subscribe((response) => {
      response = response;
      if (this.cookieService.get('user_id') !== response['cookie']){
        this.cookieService.set('user_id', response['cookie'])
      }
    })
  }

  onCreate() {
    if (this.isUnSelect()){
      this.isError = true;
    } else {
      this.isError = false;
      this.inputdateService.createWorkTimes(this.form.value).subscribe(response => {
        response = response;
        if(response['status'] == 500){
          window.location.href = this.googleUrl
        }
      });
    }

  }

  onChangeMonth($event){
    this.unselectMonth = ($event.target.value === 'null') ? true : false;
    this.change = false;
    this.max_day = new Date(this.year, $event.target.value, 0).getDate()
    for (var i = 0; i < this.max_day; i++){
      this.all_day[i] = i + 1;
    }
    this.month = $event.target.value;
  }

  onChangeday($event){
    this.unselectDay = ($event.target.value === 'null') ? true : false;
    this.change = false;
    this.day = $event.target.value;
  }

  onChangeCategory($event){
    this.unselectCategory = ($event.target.value === 'null') ? true : false;
    $event.target.value;
  }

  onChangeHour($event) {
    this.unselectHour = ($event.target.value === 'null') ? true : false;
    $event.target.value;
    
  }

  onChangeMinute($event){
    this.unselectMinute = ($event.target.value === 'null') ? true : false;
    $event.target.value;
  }

  isUnSelect(){
    if(this.unselectMinute || this.unselectHour || this.unselectDay || this.unselectMonth || this.unselectCategory) {
      return true
    } else {
      return false
    }
  }

}
