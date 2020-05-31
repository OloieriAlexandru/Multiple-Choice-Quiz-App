import { Injectable } from '@angular/core';
import { map, catchError } from 'rxjs/operators';

import { GenericService } from './generic.service';

import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private URL = environment.baseURL + 'api/v1/';

  constructor(private baseService: GenericService) {}

  public login(email: String) {
    return this.baseService.post(this.URL, 'auth', { email: email }).pipe(
      map((response: any): any => {
        if (response && response.hash) {
          localStorage.setItem('hash', response.hash);
          localStorage.setItem('email', email.toString());
          return { status: true };
        }
      }),
      catchError((err: any): any => {
        throw new Error(err.error.message);
      })
    );
  }

  public isLoggedIn(): boolean {
    let token = localStorage.getItem('hash');
    return token != null;
  }
}
