import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { AuthNotGuardService } from './services/auth-not-guard.service';
import { AuthGuardService } from './services/auth-guard.service';

import { LoginComponent } from './pages/login/login.component';
import { QuizComponent } from './pages/quiz/quiz.component';

const routes: Routes = [
  {
    path: 'login',
    component: LoginComponent,
    canActivate: [AuthNotGuardService],
  },
  {
    path: 'quiz',
    component: QuizComponent,
    canActivate: [AuthGuardService],
  },
  {
    path: '',
    redirectTo: '/login',
    pathMatch: 'full',
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
