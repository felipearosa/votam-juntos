import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bills-table"
export default class extends Controller {
  static targets = ["descriptionCell","voteDescription"]

  connect() {
    this.descriptionCellTargets.forEach(descriptionCell => {
      const voteDescription = descriptionCell.querySelector('.position');
      const hoverText = descriptionCell.querySelector('.hover-text');

      descriptionCell.addEventListener('mouseover', () => {
        voteDescription.classList.remove("inactive");
        hoverText.classList.add("hover-text-active");
      })

      descriptionCell.addEventListener('mouseout', () => {
        voteDescription.classList.add("inactive");
        hoverText.classList.remove("hover-text-active");
      })
    });
  }
}
