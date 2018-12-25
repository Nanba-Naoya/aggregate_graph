import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { InputDateComponent } from './components/input-date/input-date.component';
import { ShowGraphComponent } from './components/show-graph/show-graph.component';
import { ShowCategoryGraphComponent } from './components/show-category-graph/show-category-graph.component';
import { ShowNormalGraphComponent } from './components/show-normal-graph/show-normal-graph.component';
import { CreateCategoryComponent } from './components/create-category/create-category.component';
import { TopMenuComponent } from './components/top-menu.component';
import { InputCodeComponent } from './components/input-code/input-code.component';

NgModule({
  imports: [
    CommonModule
  ],
  declarations: []
})

const routes: Routes = [
  { path: '', component: InputDateComponent },
  { path: 'callback', component: InputDateComponent },
  { path: 'show', component: ShowGraphComponent },
  { path: 'category-graph', component:ShowCategoryGraphComponent },
  { path: 'create', component: CreateCategoryComponent },
  { path: 'normal-graph', component: ShowNormalGraphComponent },
  { path: 'top', component: TopMenuComponent },
  { path: 'code', component: InputCodeComponent}
]

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
  providers: []
})
export class AppRoutingModule { }

