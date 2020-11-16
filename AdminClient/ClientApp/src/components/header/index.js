import React from "react";
import { Icon, Dropdown, Image } from "semantic-ui-react"
import { Link } from "react-router-dom";
import "./style.scss"
import {connect} from "react-redux";
import {ADMIN_UPLOAD_FOLDER, API_URL} from "../../constants/env";
import {clearCurrentAccount} from "../../actions";

class Header extends React.Component {
    setSidebarCollapse = evt => {
        this.props.setSidebarCollapse(!this.props.sidebarCollapse);
    }
    handleSignout = evt => {
        this.props.clearAccount();
    }
    render() {
        const {account} = this.props;
        const trigger = (
            <span>
                <Image avatar src={`${API_URL}/${ADMIN_UPLOAD_FOLDER}/${account.adminAvatar}`} />
                {`${account.adminFirstName} ${account.adminLastName}`}
            </span>
        )

        return (
            <nav className="navbar navbar-expand bg-white main-header">
                <ul className="navbar-nav">
                    <li className="nav-item">
                        <button className="nav-link btn-open-sidebar" onClick={this.setSidebarCollapse}>
                            <Icon name="bars" />
                        </button>
                    </li>
                    <li>
                        <Dropdown
                            trigger={trigger}
                            pointing='top left'
                        >
                            <Dropdown.Menu>
                                <Link to="/profile" className="dropdown-item">
                                    <Dropdown.Item text='My account' icon="user" />
                                </Link>
                                <span className="dropdown-item" onClick={this.handleSignout}>
                                    <Dropdown.Item text='Sign out' icon="sign out" />
                                </span>
                            </Dropdown.Menu>
                        </Dropdown>
                    </li>
                </ul>
            </nav>
        )
    }
}

const mapStateToProps = state => {
    return {
        account: state.account
    }
}

const mapDispatchToProps = dispatch => {
    return {
        clearAccount() {
            dispatch(clearCurrentAccount())
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(Header);