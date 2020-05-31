import { Component, Input, Output, EventEmitter } from '@angular/core';
import { MatIconRegistry } from '@angular/material/icon';
import { DomSanitizer } from '@angular/platform-browser';

@Component({
  selector: 'app-navigation-bar',
  templateUrl: './navigation-bar.component.html',
  styleUrls: ['./navigation-bar.component.scss'],
})
export class NavigationBarComponent {
  @Input() public questionNumber;
  @Input() public quizFinished: boolean;
  @Output() public buttonClicked: EventEmitter<number> = new EventEmitter();

  constructor(
    private matIconRegistry: MatIconRegistry,
    private domSanitizer: DomSanitizer
  ) {
    this.matIconRegistry.addSvgIcon(
      'right_arrow',
      this.domSanitizer.bypassSecurityTrustResourceUrl(
        '/assets/arrow_forward-white-18dp.svg'
      )
    );
    this.matIconRegistry.addSvgIcon(
      'left_arrow',
      this.domSanitizer.bypassSecurityTrustResourceUrl(
        '/assets/arrow_back-white-18dp.svg'
      )
    );
  }

  public onButtonClicked(buttonId) {
    this.buttonClicked.emit(buttonId);
  }
}
