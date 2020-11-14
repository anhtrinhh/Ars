import React from "react"
import { Table, Label, Button } from "semantic-ui-react"
import { connect } from "react-redux";
import { GetFlights, SetCurrFlight, SetBookingDetailModal } from "../../actions";
import FormatDate from "../../utils/convertdate";


class FlightTable extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            flights: props.flight.currentFlights
        }
    }

    componentDidMount() {
        this.props.getFlights();
    }

    shouldComponentUpdate(nextprops, nextstate) {
        if (nextprops.flight.currentFlights.length !== nextstate.flights.length
            || nextstate.flights.length !== this.state.flights.length) {
            return true;
        }
        return false;
    }

    componentDidUpdate() {
        this.setState({
            flights: this.props.flight.currentFlights
        });
    }

    handleOpenModal = ix => {
        this.props.setCurrentFlight(ix);
        this.props.setOpenModal(true);
    }

    render() {
        let { flights } = this.state;
        let { flightDirection } = this.props;
        return (
            <React.Fragment>
                <Table celled>
                    <Table.Header>
                        <Table.Row>
                            <Table.HeaderCell width="1">No</Table.HeaderCell>
                            <Table.HeaderCell width="2">Flight Date</Table.HeaderCell>
                            <Table.HeaderCell width="2">Flight Number</Table.HeaderCell>
                            <Table.HeaderCell width="2">Booking code</Table.HeaderCell>
                            <Table.HeaderCell width="3">Departures</Table.HeaderCell>
                            <Table.HeaderCell width="3">Destinations</Table.HeaderCell>
                            <Table.HeaderCell width="1">Status</Table.HeaderCell>
                            <Table.HeaderCell width="2"></Table.HeaderCell>
                        </Table.Row>
                    </Table.Header>
                    {(flights.length > 0) &&
                        (<Table.Body>
                            {flights.map((val, ix) => (
                                <Table.Row key={ix}>
                                    <Table.Cell>{ix + 1}</Table.Cell>
                                    <Table.Cell>{FormatDate(new Date(val.flight.flightDate))}</Table.Cell>
                                    <Table.Cell>{val.flight.flightId}</Table.Cell>
                                    <Table.Cell>{val.bookingId}</Table.Cell>
                                    <Table.Cell>
                                        {flightDirection[val.flight.startPointId].city + ` (${val.flight.startPointId})`} 
                                    </Table.Cell>
                                    <Table.Cell>
                                        {flightDirection[val.flight.endPointId].city + ` (${val.flight.endPointId})`}
                                    </Table.Cell>
                                    <Table.Cell>{val.flight.flightStatus ?
                                        <Label>Completed</Label> :
                                        <Label color="teal">preparation</Label>
                                    }</Table.Cell>
                                    <Table.Cell>
                                        <Button color="green" size="small" onClick={evt => this.handleOpenModal(ix)}>Detail</Button>
                                    </Table.Cell>
                                </Table.Row>
                            ))}
                        </Table.Body>)}
                </Table>
                {(flights.length === 0) && (<h4 className="no-flight">No data available in table!</h4>)}
            </React.Fragment>
        )
    }
}

const mapStateToProps = state => {
    return {
        flight: state.Flight,
        flightDirection: state.FLightDirection
    }
}

const mapDispatchToProps = dispatch => {
    return {
        getFlights() {
            dispatch(GetFlights());
        },
        setCurrentFlight(index) {
            dispatch(SetCurrFlight(index))
        },
        setOpenModal(isOpenModal) {
            dispatch(SetBookingDetailModal(isOpenModal))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(FlightTable);