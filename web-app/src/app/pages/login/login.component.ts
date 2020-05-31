import { Component, OnInit } from '@angular/core';
import { AuthService } from 'src/app/services/auth.service';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {
  public email: String;

  constructor(
    private authService: AuthService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit(): void {}

  public login() {
    if (this.email.length < 5 || this.email.length > 32) {
      return;
    }
    this.authService.login(this.email).subscribe(
      (res) => {
        setTimeout(() => {
          let returnUrl = this.route.snapshot.queryParamMap.get('returnUrl');
          this.router.navigate([returnUrl || '/']);
        }, 2000);
      },
      (err) => {
        console.log(err);
      }
    );
  }
}
