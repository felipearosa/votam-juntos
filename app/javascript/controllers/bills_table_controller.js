import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bills-table"
export default class extends Controller {
  static targets = ["hoverText","voteDescription"]

  connect() {
    this.hoverTextTargets.forEach(hoverText => {
      const voteDescription = hoverText.querySelector('.position');

      hoverText.addEventListener('mouseover', () => {
        voteDescription.classList.remove("inactive")
      })

      hoverText.addEventListener('mouseout', () => {
        voteDescription.classList.add("inactive")
      })
    });
  }
}
