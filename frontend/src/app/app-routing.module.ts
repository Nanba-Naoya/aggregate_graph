import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { InputDateComponent } from './components/input-date/input-date.component';
import { ShowGraphComponent } from './components/show-graph/show-graph.component';
import { ShowCategoryGraphComponent } from './components/show-category-graph/show-category-graph.component';
import { ShowNormalGraphComponent } from './components/show-normal-graph/show-normal-graph.component';
import { CreateCategoryComponent } from './components/create-category/create-category.component';

NgModule({
  imports: [
    CommonModule
  ],
  declarations: []
})

const routes: Routes = [
  { path: '', component: InputDateComponent },
  { path: 'show', component: ShowGraphComponent },
  { path: 'show-category-graph', component:ShowCategoryGraphComponent },
  { path: 'create-category', component: CreateCategoryComponent },
  { path: 'show-normal-graph', component: ShowNormalGraphComponent }
]

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
  providers: []
})
export class AppRoutingModule { }

