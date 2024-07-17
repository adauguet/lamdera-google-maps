export class Polygon extends HTMLElement {
    static observedAttributes = [
        "stroke-color",
        "stroke-opacity",
        "stroke-weight",
        "fill-color",
        "fill-opacity",
        "paths"];

    constructor() {
        super();
        // console.log("polygon constructor");
        this._polygon = new google.maps.Polygon();
    }

    connectedCallback() {
        // console.log("Polygon added to page.");
        this.dispatchEvent(new CustomEvent("on-polygon-added", { bubbles: true }));
    }

    attributeChangedCallback(name, oldValue, newValue) {
        // console.log("polygon:", name, oldValue, newValue);
        switch (name) {
            case "stroke-color":
                this._polygon.setOptions({ strokeColor: newValue });
                break;
            case "stroke-opacity":
                this._polygon.setOptions({ strokeOpacity: parseFloat(newValue) });
                break
            case "stroke-weight":
                this._polygon.setOptions({ strokeWeight: parseFloat(newValue) });
                break;
            case "fill-color":
                this._polygon.setOptions({ fillColor: newValue });
                break;
            case "fill-opacity":
                this._polygon.setOptions({ fillOpacity: parseFloat(newValue) });
                break;
            case "paths":
                this._polygon.setOptions({ paths: JSON.parse(newValue) });
                break;
            default:
                console.log(`unsupported attribute: ${name}`);
                break;
        }
    }
}
