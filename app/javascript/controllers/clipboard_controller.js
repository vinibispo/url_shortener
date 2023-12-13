import { Controller } from '@hotwired/stimulus'
export default class ClipboardController extends Controller {
  static targets = ['source']
  static classes = ["supported", "unsupported"]

  connect() {
    const lastTd = this.element.querySelector('td:last-child')
    if ("clipboard" in navigator) {
      lastTd.classList.add(this.supportedClass)
    } else {
      lastTd.classList.add(this.unsupportedClass)
    }
  }

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.href)
    const buttons = this.element.parentElement.querySelectorAll('tr > td:last-child > button')
    buttons.forEach(button => button.textContent = "📋")
    const button = this.element.querySelector('td:last-child > button')

    button.textContent = "☑️"
  }
}
