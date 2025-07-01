import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star"]

  select(event) {
    event.preventDefault()
    console.log("クリックされたで！") 

    const clickedButton = event.currentTarget
    const newBadgeId = clickedButton.dataset.badgeId
    const url = clickedButton.dataset.url

    fetch(url, { method: 'PATCH', headers: { 'Accept': 'text/vnd.turbo-stream.html' } })

    this.starTargets.forEach(star => {
      if (star.dataset.badgeId === newBadgeId) {
        star.innerHTML = '<p class="text-warning fs-4 m-2">★</p>'
      } else {
        star.innerHTML = `<a href="#" data-action="click->badge#select" data-url="/badges/${star.dataset.badgeId}/select" data-badge-id="${star.dataset.badgeId}" class="btn btn-sm text-warning fs-4">☆</a>`
      }
    })
  }
}
