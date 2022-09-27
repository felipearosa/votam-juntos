import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comparison-table"
export default class extends Controller {
  static targets = ["lineComparison", "voted", "noRecord"]

  connect() {
    console.log(this.noRecordTargets)
  }


}
