import { Injectable } from '@angular/core';
import {
  HttpInterceptor,
  HttpRequest,
  HttpHandler,
  HttpEvent,
} from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class HttpInterceptorService implements HttpInterceptor {
  constructor() {}

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    const hash = localStorage.getItem('hash');
    let clone: HttpRequest<any>;

    if (hash) {
      clone = request.clone({
        setHeaders: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
          Authorization: 'Hash ' + hash,
        },
      });
    } else {
      clone = request.clone({
        setHeaders: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
        },
      });
    }

    return next.handle(clone);
  }
}
