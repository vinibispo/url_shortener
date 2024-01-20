import { Controller } from "@hotwired/stimulus"
export default class UrlFormController extends Controller {
  static targets = ["datetimeGroup", "checkbox"]

  connect() {
    this.toggleDatetimeDiv()
  }

  toggleDatetimeDiv() {
    if (this.hasDatetimeGroupTarget && this.hasCheckboxTarget) {
      this.toggleFormElements()
    }
  }

  toggleFormElements() {
    const input = this.datetimeGroupTarget.querySelector("input")
      if (this.checkboxTarget.checked) {
        this.datetimeGroupTarget.classList.remove("hidden")
        input.removeAttribute("disabled")
      } else {
        this.datetimeGroupTarget.classList.add("hidden")
        input.setAttribute("disabled", true)
      }
  }
}
