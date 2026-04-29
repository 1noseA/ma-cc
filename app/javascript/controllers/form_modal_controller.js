import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => this.element.showModal(), 800)
  }

  close() {
    this.element.close()
  }

  backdropClick(event) {
    if (event.target === this.element) this.element.close()
  }
}
