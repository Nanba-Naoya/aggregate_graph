import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { TopMenuComponent } from './components/top-menu.component';
import { ShowGraphComponent } from './components/show-graph.component';

@NgModule({
  declarations: [
    AppComponent,
    ShowGraphComponent,
    TopMenuComponent
  ],
  imports: [
    BrowserModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
