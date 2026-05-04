import { Controller } from "@hotwired/stimulus"

const SCROLL_THRESHOLD = 0.7

export default class extends Controller {
  connect() {
    this._onScroll = this._checkScroll.bind(this)
    window.addEventListener("scroll", this._onScroll, { passive: true })
  }

  disconnect() {
    window.removeEventListener("scroll", this._onScroll)
  }

  close() {
    this.element.close()
  }

  backdropClick(event) {
    if (event.target === this.element) this.element.close()
  }

  _checkScroll() {
    const scrolled = window.scrollY
    const total = document.documentElement.scrollHeight - window.innerHeight
    if (total <= 0) return
    if (scrolled / total >= SCROLL_THRESHOLD) {
      this.element.showModal()
      window.removeEventListener("scroll", this._onScroll)
    }
  }
}
