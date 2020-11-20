import React from "react"
import { connect } from "react-redux";
import { Button } from "semantic-ui-react"
import { getTimeSlot2, setSubStore, clearCurrentFlightTime } from "../../actions";
import FlightTimeList from "../../components/flight-time/flight-time-list";
import FlightTimeModal from "../../components/flight-time/flight-time-modal"

class FlightTimeDetail extends React.Component {
    componentDidMount() {
        let { from, to } = this.props.match.params;
        this.props.getCurrentFlightTimes(from, to);
    }
    handleShowModal = evt => {
        this.props.clearFlightTime();
        this.props.setModal(true)
    }
    render() {
        let { from, to } = this.props.match.params;
        let { flightDirection } = this.props;
        return (
            <div className="content-wrapper">
                <div className="content-header">
                    <div className="container-fluid">
                        <div className="row mb-2">
                            <div className="col-sm-6">
                                <h3>{flightDirection[from.toUpperCase()]
                                    ? `${flightDirection[from.toUpperCase()].city} to ` : ''}
                                    {flightDirection[to.toUpperCase()]
                                        ? `${flightDirection[to.toUpperCase()].city}` : ''}
                                </h3>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="content">
                    <div className="container-fluid">
                        <div className="row">
                            <div className="col-10">
                                <Button onClick={this.handleShowModal}>Add flight time</Button>
                            </div>
                            <div className="col-10">
                                <h4>Flight time list</h4>
                            </div>
                            <FlightTimeList />
                            <FlightTimeModal {...this.props} />
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        flightDirection: state.flightDirection
    }
}

const mapDispatchToProps = dispatch => {
    return {
        getCurrentFlightTimes(fromid, toid) {
            dispatch(getTimeSlot2(fromid, toid))
        },
        setModal(isOpen) {
            dispatch(setSubStore({openFlightTimeModal: isOpen}))
        },
        clearFlightTime() {
            dispatch(clearCurrentFlightTime())
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(FlightTimeDetail);