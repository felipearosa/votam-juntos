import { Controller } from "@hotwired/stimulus"
import { showMoreBox } from "../helpers/show_more_box";
// Connects to data-controller="comparison-table"
export default class extends Controller {
  static targets = ["lineComparison", "votedPrimary","votedSecondary", "noRecord", "votedTogether", "descriptionCell","voteDescription"]

  connect() {
    this.#checkSameness(this.lineComparisonTargets);

    const votedSame = this.#countAll(this.lineComparisonTargets, 'same-choice');
    const votedDiff = this.#countAll(this.lineComparisonTargets, 'diff-choice');

    showMoreBox(this.descriptionCellTargets);

    console.log(votedSame);
    console.log(votedDiff);

  }

  #checkSameness(arrLines){
    arrLines.forEach((tr) => {
      const primChoice = tr.querySelector('.primary-choice').innerHTML;
      const secChoice = tr.querySelector('.secondary-choice').innerHTML;

      if (primChoice === secChoice) {
        tr.classList.add('same-choice');
      } else if((primChoice === 'Sim' || primChoice === 'Não') && (secChoice === 'Sim' || secChoice === 'Não')){
        tr.classList.add('diff-choice')
      }
    });
  }


  #countAll(arrLines, className){
    let count = 0
    arrLines.forEach(tr => {
      if(tr.className.includes(className)) { count +=1 }
    });
    return count;
  }

}
