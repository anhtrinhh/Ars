import React from "react";
import { Icon } from "semantic-ui-react";
import "./style.scss";
import Logo from "./logo.png";
import { Link } from "react-router-dom";
import LinkAction from "../util-components/link-action";
import { sidebarLink } from "../../constants/link";

class SideBar extends React.Component {
    render() {
        return (
            <aside className="sidebar sidebar-dark">
                <Link to="/" className="brand-link">
                    <img src={Logo}
                        alt="Logo" className="brand-image img-circle" />
                    <span>ARS Administrator</span>
                </Link>
                <div className="sidebar-body">
                    <nav className="mt-5">
                        <ul className="nav flex-column nav-sidebar">
                            {
                                sidebarLink.map((val, ix) => (
                                    <LinkAction className="nav-link" to={val.to} key={ix} exact={val.exact}>
                                        <Icon name={val.icon} />
                                        <p>{val.label}</p>
                                    </LinkAction>
                                ))
                            }
                        </ul>
                    </nav>
                </div>
            </aside>)
    }
}

export default SideBar;