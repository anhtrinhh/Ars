import React from "react"
import { Grid } from "semantic-ui-react";
import BasicInfo from "../../components/account/basic-info";
import ContactInfo from "../../components/account/contact-info";
import ChangePassword from "../../components/account/change-password";
import LeftPanel from "../../components/account/left-panel";
import "./style.scss";
import {connect} from "react-redux";
import {Redirect} from "react-router-dom";
import ModalInform from "../../components/account/modal-inform";

class Profile extends React.Component {
    render() {
        let {subStore} = this.props;
        return subStore.isSignin ? (
            <section className="sign-wrapper">
                <div className="container">
                    <Grid>
                        <Grid.Row>
                            <Grid.Column mobile="16" tablet="5" computer="4">
                                <LeftPanel />
                            </Grid.Column>
                            <Grid.Column mobile="16" tablet="11" computer="12">
                                <div className="white-box">
                                    <div className="panel">
                                        <div className="panel-heading">
                                            <h3>My profile</h3>
                                        </div>
                                        <div className="panel-body">
                                            <h3>Personal information</h3>
                                            <BasicInfo />
                                            <h3>Contact information</h3>
                                            <ContactInfo />
                                        </div>
                                    </div>
                                    <div className="panel">
                                        <div className="panel-heading">
                                            <h3>Change password</h3>
                                        </div>
                                        <div className="panel-body">
                                            <ChangePassword />
                                        </div>
                                    </div>
                                </div>
                            </Grid.Column>
                        </Grid.Row>
                    </Grid>
                </div>
                <ModalInform />
            </section>
        ) : <Redirect to="/signin" />
    }
}

const mapStateToProps = state => {
    return {
        subStore: state.SubStore
    }
}

export default connect(mapStateToProps, null)(Profile);