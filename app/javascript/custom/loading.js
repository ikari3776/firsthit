window.addEventListener("load", () => {
const loading = document.getElementById("loading");
if (loading) {
    loading.classList.add("loaded");
}
});

document.addEventListener("DOMContentLoaded", () => {
const form = document.getElementById("search-form");
const loading = document.getElementById("loading");

if (form && loading) {
    form.addEventListener("submit", () => {
    loading.classList.remove("loaded");
    });
}
});