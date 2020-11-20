import React from "react";
import { connect } from "react-redux";
import { Table, Label} from "semantic-ui-react";
import FlightTableRow from "./flight-table-row";
import {getShortDateStr} from "../../utils/datetime-utils"

class FlightTable extends React.Component {
    render() {
        let { flights } = this.props;
        let {flightDate} = this.props.match.params;
        let isToday = getShortDateStr(new Date()) === flightDate;
        return flights.length > 0 ? (
            <Table celled className="flight-table">
                <Table.Header>
                    <Table.Row>
                        <Table.HeaderCell width="1">No</Table.HeaderCell>
                        <Table.HeaderCell width="2">Flight code</Table.HeaderCell>
                        <Table.HeaderCell width="2">Start time</Table.HeaderCell>
                        <Table.HeaderCell width="2">End time</Table.HeaderCell>
                        <Table.HeaderCell width="2">Flight times</Table.HeaderCell>
                        <Table.HeaderCell width="1">Status</Table.HeaderCell>
                        <Table.HeaderCell width="2">Flight note</Table.HeaderCell>
                        <Table.HeaderCell width="1"></Table.HeaderCell>
                        {isToday && <Table.HeaderCell>Mark departed</Table.HeaderCell>}
                    </Table.Row>
                </Table.Header>
                <Table.Body>
                    {flights.map((val, ix) => (
                        <FlightTableRow flight={val} index={ix + 1} key={ix} flightDate={flightDate} />
                    ))}
                </Table.Body>
            </Table>
        ) : <Label color="red" size="large">No data available</Label>
    }
}

const mapStateToProps = state => {
    return {
        flights: state.currentFlights
    }
}

export default connect(mapStateToProps)(FlightTable);