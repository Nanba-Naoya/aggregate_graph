import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SelectShowTypeComponent } from './select-show-type.component';

describe('SelectShowTypeComponent', () => {
  let component: SelectShowTypeComponent;
  let fixture: ComponentFixture<SelectShowTypeComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SelectShowTypeComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SelectShowTypeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
