import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bills-table"
export default class extends Controller {
  static targets = ["hoverText","voteDescription"]

  connect() {
    console.log(this.hoverTextTargets)
  }
}
