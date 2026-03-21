// src/app/persons/persons.component.ts
import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { PersonsService, Person } from '../persons';

@Component({
  selector: 'app-persons',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './persons.html'
})
export class PersonsComponent implements OnInit {
  persons: Person[] = [];
  nom = '';
  prenom = '';

  constructor(private svc: PersonsService) {}

  ngOnInit() { this.load(); }

  load() {
    this.svc.getAll().subscribe(data => this.persons = data);
  }

  submit() {
    if (!this.nom || !this.prenom) return;
    this.svc.create({ nom: this.nom, prenom: this.prenom }).subscribe(() => {
      this.nom = ''; this.prenom = '';
      this.load();
    });
  }
}