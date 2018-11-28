import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import { RouterModule } from '@angular/router';
import { FormsModule, ReactiveFormsModule } from "@angular/forms";

import { AppComponent } from './app.component';
import { TopMenuComponent } from './components/top-menu.component';
import { ShowGraphComponent } from './components/show-graph/show-graph.component';
import { InputDateComponent } from './components/input-date/input-date.component';
import { CreateCategoryComponent } from './components/create-category/create-category.component';
import { SelectShowTypeComponent} from './components/select-show-type/select-show-type.component'

import { InputDateService } from './components/services/input-date.service';
import { CreateCategoryService } from './components/services/create-category.service';
import { ShowGraphService } from './components/services/show-graph.service';

export const AppRoutes = [
  {path: "", component: TopMenuComponent},
  {path: "show", component: ShowGraphComponent},
  {path: "input-date", component: InputDateComponent},
  {path: "create-category", component: CreateCategoryComponent},
  {path: "select-show-type", component: SelectShowTypeComponent}
]

@NgModule({
  declarations: [
    AppComponent,
    ShowGraphComponent,
    TopMenuComponent,
    InputDateComponent,
    CreateCategoryComponent,
    SelectShowTypeComponent
  ],
  imports: [
    HttpClientModule,
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule.forRoot(AppRoutes)
  ],
  providers: [
    InputDateService,
    CreateCategoryService,
    ShowGraphService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
