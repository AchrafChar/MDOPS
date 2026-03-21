import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Person {
  id?: number;
  nom: string;
  prenom: string;
}

@Injectable({ providedIn: 'root' })
export class PersonsService {
  // private api = 'http://localhost:8085/api/persons';
  private api = '/api/persons';
  constructor(private http: HttpClient) {}

  getAll(): Observable<Person[]> {
    return this.http.get<Person[]>(this.api);
  }

  create(p: Person): Observable<Person> {
    return this.http.post<Person>(this.api, p);
  }
}