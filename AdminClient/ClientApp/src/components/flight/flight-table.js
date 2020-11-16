import React from "react";
import { connect } from "react-redux";
import { Table, Label, Button } from "semantic-ui-react";
import { getMediumTimeStr, subtractTime } from "../../utils/datetime-utils";

class FlightTable extends React.Component {
    render() {
        let { flights } = this.props;
        return flights.length > 0 ? (
            <Table celled>
                <Table.Header>
                    <Table.Row>
                        <Table.HeaderCell width="1">No</Table.HeaderCell>
                        <Table.HeaderCell width="2">Flight code</Table.HeaderCell>
                        <Table.HeaderCell width="2">Start time</Table.HeaderCell>
                        <Table.HeaderCell width="2">End time</Table.HeaderCell>
                        <Table.HeaderCell width="2">Flight times</Table.HeaderCell>
                        <Table.HeaderCell>Status</Table.HeaderCell>
                        <Table.HeaderCell width="3">Flight note</Table.HeaderCell>
                        <Table.HeaderCell></Table.HeaderCell>
                    </Table.Row>
                </Table.Header>
                <Table.Body>
                    {flights.map((val, ix) => (
                        <Table.Row key={ix}>
                            <Table.Cell>{ix + 1}</Table.Cell>
                            <Table.Cell>{val.flightId}</Table.Cell>
                            <Table.Cell>{getMediumTimeStr(val.startTime)}</Table.Cell>
                            <Table.Cell>{getMediumTimeStr(val.endTime)}</Table.Cell>
                            <Table.Cell>{subtractTime(val.endTime, val.startTime)}</Table.Cell>
                            <Table.Cell>
                                {val.flightStatus
                                    ? <Label color="green" style={{ cursor: "pointer" }}>Departed</Label>
                                    : <Label style={{ cursor: "pointer" }}>Not departed</Label>}
                            </Table.Cell>
                            <Table.Cell>{val.flightNote}</Table.Cell>
                            <Table.Cell>
                                <Button color="yellow" size="mini">Edit</Button>
                                <Button color="green" size="mini">Detail</Button>
                            </Table.Cell>
                        </Table.Row>
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