import { Controller } from "@hotwired/stimulus"

export default class LanguageController extends Controller {
  connect() {
    console.log("connect")
  }

  changeLocale(e) {
    const currentValue = this.element.value
    console.log("change")
    // Add authenticity token
    const authenticity_token = document.querySelector("meta[name='csrf-token']").content
    const body = JSON.stringify({
      authenticity_token: authenticity_token
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
