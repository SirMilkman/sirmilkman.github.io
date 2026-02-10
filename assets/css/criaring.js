class WebRing extends HTMLElement {
  connectedCallback() {
    fetch("https://criar.ing/webring.json")
      .then((response) => response.json())
      .then((sites) => {
        const name = window.location.href.split('/').filter(part => part.includes('.'))[0];
        const index = sites.findIndex(site => site.url.includes(`/${name}`));
        const next = (index + 1) % sites.length;
        const prev = (index + (sites.length - 1)) % sites.length;
        const random = Math.floor(Math.random() * sites.length);
        const template = document.createElement("template");
        template.innerHTML = `
        <style>
            .list {
              line-height: 48px;
            }
            .linky {
              color: var(--mg-color) !important;
              background-color: black!important;
              text-decoration: underline;
              padding: 7px;
              padding-top: 7px;
              padding-bottom: 4px;
              
              border: 2px dashed black !important;
            }
            .linky:hover{
              color: black !important;
              background-color: var(--mg-color) !important;
            }
          </style>

        <div class="list">
          <a class="linky" href="${sites[next].url}">next</a>
          <a class="linky" href="${sites[prev].url}">previous</a>
          <a class="linky" href="${sites[random].url}">random</a>
        </div>
        `
        this.attachShadow({ mode: "open" });
        this.shadowRoot.appendChild(template.content.cloneNode(true));
      });
  }
}

window.customElements.define("webring-css", WebRing);
