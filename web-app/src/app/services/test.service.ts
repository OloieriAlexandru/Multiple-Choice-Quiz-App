import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { GenericService } from './generic.service';

import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root',
})
export class TestService {
  private URL = environment.baseURL + 'api/v1/';

  constructor(private baseService: GenericService) {}

  private buildBody() {
    return {
      email: localStorage.getItem('email'),
      hash: localStorage.getItem('hash'),
      questionResponse: null,
    };
  }

  public getQuestionOrResult(): Observable<any> {
    let body = this.buildBody();
    return this.baseService.post<any>(this.URL, 'tests', body);
  }

  public sendQuestionResponse(response: String): Observable<any> {
    let body = this.buildBody();
    body.questionResponse = response;
    return this.baseService.post<any>(this.URL, 'tests', body);
  }
}
