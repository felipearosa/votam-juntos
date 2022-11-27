import { Controller } from "@hotwired/stimulus"
import { showMoreBox } from "../helpers/show_more_box"

// Connects to data-controller="bills-table"
export default class extends Controller {
  static targets = ["descriptionCell","voteDescription"]

  connect() {
    showMoreBox(this.descriptionCellTargets);
  }
}
