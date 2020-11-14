import { Link } from "react-router-dom";
import LinkAction from "../util-components/LinkAction";
import "./style/mobilemenu.scss";

export default function MobileMenu({dataToggle}){
    return (
        <div className={(dataToggle ? "active ": "") + "mobile-menu"}>
            <div className="mobile-menu__inner">
                <div className="mobile-menu__link">
                    <Link to="/">Booking</Link>
                </div>
                <div className="mobile-menu__link">
                    <Link to="/">Travel information</Link>
                </div>
                <div className="mobile-menu__link">
                    <Link to="/">Contact</Link>
                </div>
                <div className="mobile-menu__sign">
                    <ul className="clearfix">
                        <LinkAction to="/signup" label="Sign Up" />
                        <LinkAction to="/signin" label="Sign In" />
                    </ul>
                </div>
            </div>
        </div>
    )
}