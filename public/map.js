export class Map extends HTMLElement {
    static observedAttributes = ["lat", "lng", "zoom"];

    constructor() {
        super();
        // console.log("map constructor");
        this.attachShadow({ mode: "open" });

        const mapContainer = document.createElement("div");
        mapContainer.setAttribute("style", "height:100%;width:100%;");
        this.shadowRoot.append(mapContainer);

        this._map = new google.maps.Map(mapContainer, {
            center: { lat: 0, lng: 0 },
            zoom: 0,
        });

        const containerTemplate = document.createElement("template");
        containerTemplate.innerHTML = `<slot></slot>`;
        this.shadowRoot.appendChild(containerTemplate.content.cloneNode(true));

        this.addEventListener("on-polygon-added", () => {
            this.setPolygonsMap();
        }, false);
    }

    connectedCallback() {
        // console.log("Map added to page.");
        this.setPolygonsMap();
    }

    attributeChangedCallback(name, oldValue, newValue) {
        // console.log("map:", name, oldValue, newValue);
        switch (name) {
            case "lat":
                this._map.setCenter({ lat: parseFloat(newValue), lng: this._map.getCenter().lng() })
                break;
            case "lng":
                this._map.setCenter({ lat: this._map.getCenter().lat(), lng: parseFloat(newValue) })
                break;
            case "zoom":
                this._map.setZoom(parseInt(newValue));
                break;
            default:
                console.log(`unsupported attribute: ${name}`);
                break;
        }
    }

    setPolygonsMap() {
        const polygons = this.querySelectorAll("google-polygon");
        Array.from(polygons).forEach((polygon) => {
            polygon._polygon.setMap(this._map);
        })
    }
}
