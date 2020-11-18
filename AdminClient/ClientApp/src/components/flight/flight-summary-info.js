import React from "react";
import { connect } from "react-redux";
import SummaryBasic from "./summary-basic-info";
import SummaryTicket from "./summary-ticket-info";
import {Button} from "semantic-ui-react";
import {insertFlight} from "../../actions";
import {getShortDateStr} from "../../utils/datetime-utils"
 
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
    handleSubmit = evt => {
        let {basicInfo, ticketInfo, token, subStore} = this.props;
        let flight = {...basicInfo};
        let list = [];
        if (subStore.showEconomy) {
            list.push(ticketInfo[0]);
        }
        if (subStore.showPremium) {
            list.push(ticketInfo[1])
        }
        if (subStore.showBusiness) {
            list.push(ticketInfo[2]);
        }
        flight.date = getShortDateStr(flight.date);
        this.props.insertFlight(flight, list, token);
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
                    <div className="col-10 mt-3 d-flex justify-content-center">
                        <Button size="large" color="green" onClick={this.handleSubmit}>Add flight</Button>
                    </div>
                </div>
            </React.Fragment>
        )
    }
}

const mapStateToProps = state => {
    return {
        ticketInfo: state.flightTicketInfo,
        basicInfo: state.flightBasicInfo,
        token: state.account.jwtToken,
        subStore: state.subStore
    }
}

const mapDispatchToProps = dispatch => {
    return {
        insertFlight(flight, ticketClasses, token) {
            dispatch(insertFlight(flight, ticketClasses, token))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(SummaryInfo);