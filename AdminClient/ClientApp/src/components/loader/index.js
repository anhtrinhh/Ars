import Gif from "./loader.gif";
import "./loader.scss";

export default function Loader() {
    return (
        <div className="ars-loader">
            <img src={Gif} alt="Loadding"/>
        </div>
    );
}