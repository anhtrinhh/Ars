import {Link} from "react-router-dom";
import LinkAction from "../../components/util-components/LinkAction";
import "./style/submenu.scss";

export default function SubMenu(){
    return (
        <div className="sub-menu">
            <div className="container">
                <div className="sub-menu__col">
                    <Link to="/" className="title"><h3>Book your trip</h3></Link>
                    <ul>
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                    </ul>
                </div>
                <div className="sub-menu__col">
                    <Link to="/" className="title"><h3>Book your trip</h3></Link>
                    <ul>
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                    </ul>
                </div>
                <div className="sub-menu__col">
                    <Link to="/" className="title"><h3>Book your trip</h3></Link>
                    <ul>
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                    </ul>
                </div>
                <div className="sub-menu__col">
                    <Link to="/" className="title"><h3>Book your trip</h3></Link>
                    <ul>
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                        <LinkAction to="/" label="Online booking guidance" />
                    </ul>
                </div>
            </div>
        </div>
    )
}