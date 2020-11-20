import React from "react";
import BasicInfo from "../../components/flight/flight-basic-info";
import TicketInfo from "../../components/flight/flight-ticket-info";
import SummaryInfo from "../../components/flight/flight-summary-info";

class FlightAdd extends React.Component {
    render() {
        let { step } = this.props.match.params;
        return (
            <div className="content-wrapper">
                <div className="content-header">
                    <div className="container-fluid">
                        <div className="row mb-2">
                            <div className="col-12">
                                <h3>Add Flight</h3>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="content">
                    <div className="container-fluid">
                        {
                            Number(step) === 1 ? <BasicInfo {...this.props} />
                                : Number(step) === 2 ? <TicketInfo {...this.props} />
                                    : <SummaryInfo {...this.props} />
                        }
                    </div>
                </div>
            </div>
        )
    }
}

export default FlightAdd;