import { Component, Input, Output, EventEmitter } from '@angular/core';

import { Question } from 'src/app/models/question';

@Component({
  selector: 'app-question',
  templateUrl: './question.component.html',
  styleUrls: ['./question.component.scss'],
})
export class QuestionComponent {
  @Input() public question: Question;
  @Output() public answerChanged: EventEmitter<any> = new EventEmitter();

  constructor() {}

  public onAnswerChanged(obj) {
    this.answerChanged.emit(obj);
  }
}
