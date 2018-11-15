import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpModule } from '@angular/http'
import { RouterModule } from '@angular/router';

import { AppComponent } from './app.component';
import { TopMenuComponent } from './components/top-menu.component';
import { ShowGraphComponent } from './components/show-graph.component';
import { InputDataComponent } from './components/input-data.component';

export const AppRoutes = [
  {path: "", component: TopMenuComponent},
  {path: "show", component: ShowGraphComponent},
  {path: "input-data", component: InputDataComponent},
]

@NgModule({
  declarations: [
    AppComponent,
    ShowGraphComponent,
    TopMenuComponent,
    InputDataComponent
  ],
  imports: [
    HttpModule,
    BrowserModule,
    RouterModule.forRoot(AppRoutes)
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
