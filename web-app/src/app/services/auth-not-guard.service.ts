import { Injectable } from '@angular/core';
import { Router, CanActivate, RouterStateSnapshot } from '@angular/router';

import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root',
})
export class AuthNotGuardService implements CanActivate {
  constructor(private router: Router, private authService: AuthService) {}

  canActivate(route, state: RouterStateSnapshot) {
    if (!this.authService.isLoggedIn()) {
      return true;
    }

    this.router.navigate(['/quiz']);
    return false;
  }
}
