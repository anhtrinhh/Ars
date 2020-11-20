import React from "react"
import { connect } from "react-redux";
import { Segment } from "semantic-ui-react";
import { getLongDateStr, getMediumTimeStr } from "../../utils/datetime-utils";

class BasicInfo extends React.Component {
    render() {
        let { currentFlight, flightDirection } = this.props;
        return (
            <Segment className="row col-10">
                <div className="col-12">
                    <h4>Basic information</h4>
                </div>
                <div className="col-10">
                    <div className="row mb-3">
                        <div className="col-2">
                            <b>Flight code:</b>
                        </div>
                        <div className="col-4">
                            <span>{currentFlight.flightId}</span>
                        </div>
                        <div className="col-2">
                            <b>Flight date:</b>
                        </div>
                        <div className="col-4">
                            <span>{getLongDateStr(new Date(currentFlight.flightDate))}</span>
                        </div>
                    </div>
                    <div className="row mb-3">
                        <div className="col-2">
                            <b>From:</b>
                        </div>
                        <div className="col-4">
                            <span>{flightDirection[currentFlight.startPointId]
                                ? flightDirection[currentFlight.startPointId].city
                                : ''}</span>
                        </div>
                        <div className="col-2">
                            <b>To:</b>
                        </div>
                        <div className="col-4">
                            <span>{flightDirection[currentFlight.startPointId]
                                ? flightDirection[currentFlight.endPointId].city
                                : ''}</span>
                        </div>
                    </div>
                    <div className="row mb-3">
                        <div className="col-2">
                            <b>Start time:</b>
                        </div>
                        <div className="col-4">
                            <span>{getMediumTimeStr(currentFlight.startTime)}</span>
                        </div>
                        <div className="col-2">
                            <b>End Time:</b>
                        </div>
                        <div className="col-4">
                            <span>{getMediumTimeStr(currentFlight.endTime)}</span>
                        </div>
                    </div>
                    <div className="row mb-3">
                        <div className="col-2">
                            <b>Flight status:</b>
                        </div>
                        <div className="col-4">
                            <span>{currentFlight.flightStatus ? 'Departed' : 'Not departed'}</span>
                        </div>
                    </div>
                    <div className="row mb-3">
                        <div className="col-2">
                            <b>Flight note:</b>
                        </div>
                        <div className="col-4">
                            <span>{currentFlight.flightNote}</span>
                        </div>
                    </div>
                </div>
            </Segment>
        )
    }
}

const mapStateToProps = state => {
    return {
        flightDirection: state.flightDirection,
        currentFlight: state.currentFlight
    }
}

export default connect(mapStateToProps)(BasicInfo);