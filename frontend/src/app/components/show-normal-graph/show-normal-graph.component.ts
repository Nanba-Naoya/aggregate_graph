import { Component, OnInit } from '@angular/core';
import { CookieService } from 'ngx-cookie-service';
import { ToastrService } from 'ngx-toastr';

import { ShowGraphService } from '../services/show-graph.service'
import { Category } from '../category';
import { FormGroup, FormControl } from '@angular/forms';
import { environment } from '../../../environments/environment'

@Component({
  selector: 'app-show-normal-graph',
  templateUrl: './show-normal-graph.component.html',
  styleUrls: ['./show-normal-graph.component.css']
})
export class ShowNormalGraphComponent implements OnInit {
  googleUrl = environment.googleUrl;
  form: FormGroup
  categories: Category;
  month;
  day;
  category_flag = false;
  change = false;
  type_flag = false;
  data;
  users;
  names;
  lists;
  eventData;

  constructor(private showGraphService: ShowGraphService,
              private cookieService: CookieService,
              private toastr: ToastrService) {
    this.form = new FormGroup({
      month: new FormControl(),
      day: new FormControl(),
      type_flag: new FormControl(),
    });
   }

  ngOnInit() {
    if (this.cookieService.get('user_id') == ''){
      window.location.href = this.googleUrl
    }
  }

  onReceiveMonth(eventData) {
    if (eventData !== null){
      this.change = false
      this.month = eventData
      this.form['month'] = eventData
    }
  }

  onReceiveDay(eventData) {
      this.change = false
      this.day = eventData;
      this.form['day'] = eventData
  }

  onShowGraph(){
    this.form['type_flag'] = false
    if (this.form['month'] !== undefined){
      this.showGraphService.getWorkTimes(this.form).subscribe((response) => {
        this.data = response;
        this.showGraphService.getUsrsLists(this.form).subscribe((response)=> {
          this.users = response;
          
          var users_lists = [];
          for (var item in this.users){
            users_lists.push(item+ ' : '+ this.users[item])
          }
          this.names = users_lists

        })
        if (this.data['status'] == 404){
          this.toastr.error(this.data['message']);
        } else {
          this.change = true
        }
      })
    }
  }

}
