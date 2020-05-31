import { Component, Input, OnInit, Output, EventEmitter } from '@angular/core';
import { MatIconRegistry } from '@angular/material/icon';
import { DomSanitizer } from '@angular/platform-browser';

@Component({
  selector: 'app-question-answer',
  templateUrl: './question-answer.component.html',
  styleUrls: ['./question-answer.component.scss'],
})
export class QuestionAnswerComponent implements OnInit {
  @Input() public answer: any;
  @Input() public answerScore: any;
  @Output() public answerChanged: EventEmitter<any> = new EventEmitter();
  public checked: boolean = null;
  public final: boolean = false;
  public correct: number = null;

  constructor(
    private matIconRegistry: MatIconRegistry,
    private domSanitizer: DomSanitizer
  ) {
    this.matIconRegistry.addSvgIcon(
      'correct_ans',
      this.domSanitizer.bypassSecurityTrustResourceUrl(
        '/assets/check-white-18dp.svg'
      )
    );
    this.matIconRegistry.addSvgIcon(
      'wrong_ans',
      this.domSanitizer.bypassSecurityTrustResourceUrl(
        '/assets/clear-white-18dp.svg'
      )
    );
  }

  ngOnInit() {
    if (this.answer.hasOwnProperty('selected')) {
      this.checked = this.answer.selected;
    } else {
      this.checked = false;
    }
    if (this.answer.hasOwnProperty('corect')) {
      this.correct = this.answer.corect;
      this.final = true;
    }
  }

  public onValueChanged(value) {
    if (this.final) {
      return;
    }
    this.checked = !value;
    this.answerChanged.emit({
      checked: this.checked,
      id: this.answer.id_raspuns,
    });
  }
}
