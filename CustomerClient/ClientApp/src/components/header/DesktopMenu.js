import LinkAction from "../util-components/LinkAction";
import SubMenu from "./SubMenu";
import "./style/desktopmenu.scss";

export default function DesktopMenu(){
    return (
        <ul className="desktop-menu">
            <LinkAction to="/article/booking" label="Booking">
                <SubMenu/>
            </LinkAction>
            <LinkAction to="/article/travel-info" label="Travel information">
                <SubMenu/>
            </LinkAction>
            <LinkAction to="/contact" label="Contact">
                <SubMenu/>
            </LinkAction>
        </ul>
    )
}