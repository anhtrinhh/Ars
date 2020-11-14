import LinkAction from "../util-components/LinkAction";
import "./style/headertop.scss";
import { Dropdown, Image } from 'semantic-ui-react';
import { connect } from "react-redux";
import React, { Fragment } from "react";
import { GetCustomer, SetSignin } from "../../actions";
import { Link } from "react-router-dom";



class HeaderTop extends React.Component {
    componentDidMount() {
        this.props.getCustomer();
    }
    render() {
        const { customerEmail, customerFirstName, customerLastName, customerAvatar } = this.props.customer;
        const trigger = (
            <span>
                <Image avatar src={customerAvatar} />
                {customerFirstName + ' ' + customerLastName}
            </span>
        )
        return (
            <div className="header-top">
                <div className="container">
                    <div>
                        <ul className="clearfix">
                            {customerEmail ? (
                                <li><Dropdown
                                    trigger={trigger}
                                    pointing='top left'
                                >
                                    <Dropdown.Menu>
                                        <Link to="/profile" className="menu-link">
                                            <Dropdown.Item text='My account' icon="user" />
                                        </Link>
                                        <Link to="/myflights" className="menu-link">
                                            <Dropdown.Item text='My flights' icon="plane" />
                                        </Link>
                                        <Link to="/signin" className="menu-link">
                                            <Dropdown.Item text='Sign out' icon="sign out" />
                                        </Link>
                                    </Dropdown.Menu>
                                </Dropdown></li>
                            ) : (
                                    <Fragment>
                                        <LinkAction to="/signup" label="Sign Up" />
                                        <LinkAction to="/signin" label="Sign In" />
                                    </Fragment>
                                )}
                        </ul>
                    </div>
                </div>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        customer: state.Customer
    }
}

const mapDispatchToProps = (dispatch, props) => {
    return {
        getCustomer() {
            let token = sessionStorage.getItem("token") || localStorage.getItem("token");
            if (token) {
                dispatch(GetCustomer(token))
            } else {
                dispatch(SetSignin(false))
            }
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(HeaderTop);