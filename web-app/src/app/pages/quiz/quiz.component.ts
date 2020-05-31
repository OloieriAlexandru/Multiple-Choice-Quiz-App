import { Component, OnInit } from '@angular/core';

import { TestService } from 'src/app/services/test.service';

import { Question } from 'src/app/models/question';

@Component({
  selector: 'app-quiz',
  templateUrl: './quiz.component.html',
  styleUrls: ['./quiz.component.scss'],
})
export class QuizComponent implements OnInit {
  public response: any = null;
  public questionNumber: number = null;
  public quizFinished: boolean = null;
  public currentQuestion: Question = null;
  public score: number = null;
  public questionsScores: any[] = null;
  private questions: Question[] = null;
  private selectedAnswers: any[];

  constructor(private testService: TestService) {}

  ngOnInit(): void {
    this.testService.getQuestionOrResult().subscribe(
      (res) => {
        this.handleResponse(res);
      },
      (err) => {
        console.log(err);
      }
    );
  }

  private handleResponse(res) {
    res = JSON.parse(res.response);
    if (res.hasOwnProperty('punctaj')) {
      this.quizFinished = true;
      this.questionNumber = 100;
      this.score = res.punctaj;
      this.questionsScores = res.punctaje_intrebari;
      this.questions = this.buildQuestions(
        res.intrebari,
        res.punctaje_intrebari
      );
    } else {
      this.quizFinished = false;
      this.currentQuestion = new Question(res.text_intrebare, res.raspunsuri);
      this.questionNumber = (res.numar_ordine - 1) * 10;
      this.selectedAnswers = [res.id_intrebare];
    }
    this.response = res;
  }

  private buildQuestions(rawQuestions, userQuestionsScores) {
    let questions = [];
    for (let i = 0; i < rawQuestions.length; ++i) {
      questions.push(this.buildQuestion(rawQuestions[i]));
      questions[i].setUserScore(userQuestionsScores[i]);
    }

    return questions;
  }

  private buildQuestion(rawQuestion) {
    let userAnswers = rawQuestion.raspuns_utilizator.split(',');
    for (let i = 0; i < rawQuestion.raspunsuri.length; ++i) {
      rawQuestion.raspunsuri[i].selected = false;
    }
    for (let i = 0; i < userAnswers.length; ++i) {
      this.updateQuestionAnswers(rawQuestion.raspunsuri, userAnswers[i]);
    }
    let correctAnswers = this.countQuestionCorrectAnswers(
      rawQuestion.raspunsuri
    );
    let question = new Question(
      rawQuestion.text_intrebare,
      rawQuestion.raspunsuri
    );
    question.setAnswerScore(Math.round((10.0 / correctAnswers) * 100) / 100);
    return question;
  }

  private updateQuestionAnswers(answers, answerId) {
    for (let i = 0; i < answers.length; ++i) {
      if (answers[i].id_raspuns == answerId) {
        answers[i].selected = true;
      }
    }
  }

  private countQuestionCorrectAnswers(answers) {
    let result = 0;
    for (let i = 0; i < answers.length; ++i) {
      if (answers[i].corect == 1) {
        ++result;
      }
    }
    return result;
  }

  public onButtonClicked(buttonId) {
    if (buttonId == 1) {
      this.onPreviousButtonClicked();
    } else {
      this.onNextButtonClicked();
    }
  }

  private onPreviousButtonClicked() {
    if (!this.quizFinished) {
      return;
    }
    this.questionNumber -= 10;
    this.currentQuestion = this.questions[this.questionNumber / 10];
  }

  private onNextButtonClicked() {
    if (!this.quizFinished) {
      if (this.selectedAnswers.length == 1) {
        return;
      }
      this.testService
        .sendQuestionResponse(this.selectedAnswers.join(','))
        .subscribe((res) => {
          this.handleResponse(res);
        });
    } else {
      this.questionNumber += 10;
      if (this.questionNumber < 100) {
        this.currentQuestion = this.questions[this.questionNumber / 10];
      }
    }
  }

  public onAnswerChanged(obj) {
    if (obj.checked) {
      this.selectedAnswers.push(obj.id);
    } else {
      let index = this.selectedAnswers.indexOf(obj.id);
      if (index >= 0) {
        this.selectedAnswers.splice(index, 1);
      }
    }
  }
}
