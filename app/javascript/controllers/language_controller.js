import { Controller } from "@hotwired/stimulus"

export default class LanguageController extends Controller {
  static targets = ["action", "controller"]

  changeLocale(e) {
    const currentValue = this.element.firstElementChild.value
    const controller = this.controllerTarget.value
    const action = this.actionTarget.value

    const authenticity_token = document.querySelector("meta[name='csrf-token']").content
    const body = JSON.stringify({
      authenticity_token: authenticity_token,
      language: {
        controller: controller,
        action: action,
      }
    })
    fetch(
      this.urlForLocaleChange(e.target.value),
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: body
      }
    )
      .then((response) => {
        if (response.redirected) {
          window.Turbo.visit(response.url)
        }
      })
    .catch((error) => {
      console.log(error)
      this.element.value  = currentValue
    })
  }

  urlForLocaleChange(locale) {
    return `/change_locale/${locale}`
  }
}
