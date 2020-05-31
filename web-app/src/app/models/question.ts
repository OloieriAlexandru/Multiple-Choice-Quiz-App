export class Question {
  text: String;
  answers: any[];
  answerScore?: any;
  userScore: any;

  constructor(text, answers) {
    this.text = text;
    this.answers = answers;
  }

  setAnswerScore(answerScore) {
    this.answerScore = answerScore;
  }

  setUserScore(userScore) {
    this.userScore = userScore;
  }
}
