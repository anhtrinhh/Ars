import React from "react";
import { connect } from "react-redux";
import SummaryBasic from "./summary-basic-info";
import SummaryTicket from "./summary-ticket-info";

class SummaryInfo extends React.Component {
    constructor(props) {
        super(props);
        this.checkValidate(props);
    }

    checkValidate(props) {
        if (props.location.state) {
            let { showEconomy, showBusiness, showPremium } = props.location.state;
            let { ticketInfo } = props;
            if (!showBusiness && !showEconomy && !showPremium) {
                props.history.goBack();
            } else if (showEconomy && ticketInfo[0].numberTicket === '') {
                props.history.goBack();
            } else if (showPremium && ticketInfo[1].numberTicket === '') {
                props.history.goBack();
            } else if (showBusiness && ticketInfo[2].numberTicket === '') {
                props.history.goBack();
            }
        } else {
            props.history.goBack();
        }
    }
    render() {
        return (
            <React.Fragment>
                <h4>Confirm information</h4>
                <div className="row">
                    <div className="col-10">
                        <SummaryBasic />
                    </div>
                    <div className="col-10 mt-4">
                        <SummaryTicket showTicketClass={this.props.location.state}/>
                    </div>
                </div>
            </React.Fragment>
        )
    }
}

const mapStateToProps = state => {
    return {
        ticketInfo: state.flightTicketInfo
    }
}

export default connect(mapStateToProps)(SummaryInfo);