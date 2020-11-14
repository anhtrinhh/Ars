import "./style/header.scss"
import {Fragment, useState } from "react";
import { Link } from "react-router-dom";
import DesktopMenu from "./DesktopMenu";
import Logo from "../../app/images/logo.png";
import { CancelIcon, BarIcon } from "../../icons";
import HeaderTop from "./HeaderTop";
import MobileMenu from "./MobileMenu";

export default function Header(){
    let [toggle, setToggle] = useState(false);
    const toggleMenu = () => {
        setToggle(!toggle);
    }
    return (
        <Fragment>
            <HeaderTop />
            <header className="header">
                <div className="navigation">
                    <div className="container">
                        <nav>
                            <div className="navigation__logo">
                                <Link to="/">
                                    <img src={Logo} alt="Logo" />
                                </Link>
                            </div>
                            <DesktopMenu />
                            <div
                                className="btn-toggle-menu"
                                onClick={toggleMenu}
                            >
                                <span>Menu</span>
                                {toggle ? <CancelIcon /> : <BarIcon />}
                            </div>
                        </nav>
                    </div>
                    <MobileMenu dataToggle={toggle} />
                </div>
            </header>
        </Fragment>
    )
}