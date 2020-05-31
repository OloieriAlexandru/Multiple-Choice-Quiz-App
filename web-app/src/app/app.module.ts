import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { FormsModule } from '@Angular/forms';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCheckboxModule } from '@angular/material/checkbox';

import { GenericService } from './services/generic.service';
import { AuthService } from './services/auth.service';
import { AuthGuardService } from './services/auth-guard.service';
import { AuthNotGuardService } from './services/auth-not-guard.service';
import { HttpInterceptorService } from './services/http-interceptor.service';

import { LoginComponent } from './pages/login/login.component';
import { QuizComponent } from './pages/quiz/quiz.component';
import { NavigationBarComponent } from './components/navigation-bar/navigation-bar.component';
import { QuestionComponent } from './components/question/question.component';
import { QuestionAnswerComponent } from './components/question-answer/question-answer.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    QuizComponent,
    NavigationBarComponent,
    QuestionComponent,
    QuestionAnswerComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    MatProgressBarModule,
    MatProgressSpinnerModule,
    MatButtonModule,
    BrowserAnimationsModule,
    MatIconModule,
    MatCheckboxModule,
  ],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: HttpInterceptorService,
      multi: true,
    },
    GenericService,
    AuthService,
    AuthGuardService,
    AuthNotGuardService,
  ],
  bootstrap: [AppComponent],
})
export class AppModule {}
