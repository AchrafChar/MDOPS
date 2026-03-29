import { Component, signal } from '@angular/core';
import { PersonsComponent } from './persons/persons';

@Component({
  selector: 'app-root',
  imports: [PersonsComponent], 
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('mdops-frontend');
}
