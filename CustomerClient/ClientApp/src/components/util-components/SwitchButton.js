import "./style.scss";

export default function SwitchButton(){
    return (
        <label className="switch-button">
            <input type="checkbox" />
            <span className="background"></span>
            <span className="mask"></span>
        </label>
    )
}