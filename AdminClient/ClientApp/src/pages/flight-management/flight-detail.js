import React from "react"
import {connect} from "react-redux";
import {getFlightByFlightId} from "../../actions"
import BasicInfo from "../../components/flight-detail/basic-info";
import TicketInfo from "../../components/flight-detail/ticket-info";

class FlightDetail extends React.Component {
    constructor(props) {
        super(props);
        props.getFlight(props.match.params.flightId);
    }
    render() {
        return (
            <div className="content-wrapper">
                <div className="content-header">
                    <div className="container-fluid">
                        <div className="row mb-2">
                            <div className="col-12">
                                <h3>Flight Detail</h3>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="content">
                    <div className="container-fluid">
                        <BasicInfo />
                        <TicketInfo />
                    </div>
                </div>
            </div>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return {
        getFlight(flightId) {
            dispatch(getFlightByFlightId(flightId))
        }
    }
}

export default connect(null, mapDispatchToProps)(FlightDetail);