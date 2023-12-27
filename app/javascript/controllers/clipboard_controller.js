import { Controller } from '@hotwired/stimulus'
export default class ClipboardController extends Controller {
  static targets = ['source']
  static classes = ["supported", "unsupported"]

  connect() {
    const copyTd = this.element.querySelector('td[data-copy="true"]')
    if ("clipboard" in navigator) {
      copyTd.classList.add(this.supportedClass)
    } else {
      copyTd.classList.add(this.unsupportedClass)
    }
  }

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.href)
    const buttons = this.element.parentElement.querySelectorAll('tr > td[data-copy="true"] > button')
    buttons.forEach(button => button.textContent = "📋")
    const button = this.element.querySelector('td[data-copy="true"]> button')

    button.textContent = "☑️"
  }
}
