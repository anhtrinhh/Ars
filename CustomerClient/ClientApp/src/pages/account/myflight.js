import React from "react";
import "./style.scss";
import { Grid } from "semantic-ui-react";
import FlightTable from "../../components/account/flight-table";
import FlightPagi from "../../components/account/flight-pagi";
import BookingModal from "../../components/account/booking-modal";
import {connect} from "react-redux";
import {Redirect} from "react-router-dom";

class MyFlight extends React.Component {
    render() {
        let {subStore} = this.props;
        return subStore.isSignin ? (
            <section className="sign-wrapper">
                <div className="container">
                    <Grid>
                        <Grid.Row columns="1">
                            <Grid.Column>
                                <div className="white-box">
                                    <div className="panel">
                                        <div className="panel-heading">
                                            <h3>Flight history</h3>
                                        </div>
                                        <div className="panel-body">
                                            <h3>My flight list</h3>
                                            <FlightTable />
                                        </div>
                                        <div className="panel-footer">
                                            <FlightPagi />
                                        </div>
                                    </div>
                                </div>
                            </Grid.Column>
                        </Grid.Row>
                    </Grid>
                </div>
                <BookingModal />
            </section>
        ) : <Redirect to="/signin" />
    }
}

const mapStateToProps = state => {
    return {
        subStore: state.SubStore
    }
}

export default connect(mapStateToProps, null)(MyFlight);