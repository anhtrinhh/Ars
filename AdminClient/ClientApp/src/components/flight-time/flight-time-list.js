import React from "react"
import { Table } from "semantic-ui-react"
import FlightTimeItem from "./flight-time-item"
import { connect } from "react-redux";

class FLightTimeList extends React.Component {
    render() {
        let { currentFlightTimes } = this.props;
        return (
            <div className="col-8">
                <Table celled>
                    <Table.Header>
                        <Table.Row>
                            <Table.HeaderCell>No</Table.HeaderCell>
                            <Table.HeaderCell>Start time</Table.HeaderCell>
                            <Table.HeaderCell>End time</Table.HeaderCell>
                            <Table.HeaderCell>Flight time</Table.HeaderCell>
                            <Table.HeaderCell width="4"></Table.HeaderCell>
                        </Table.Row>
                    </Table.Header>
                    {(currentFlightTimes.length > 0) && (
                        <Table.Body>
                            {
                                currentFlightTimes.map((val, ix) => (
                                    <FlightTimeItem key={ix} index={ix+1} flightTime={val} />
                                ))
                            }
                        </Table.Body>
                    )}
                </Table>
                {(currentFlightTimes.length === 0) && (<h4 className="text-danger">No data available in table!</h4>)}
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        currentFlightTimes: state.currentFlightTimes
    }
}

export default connect(mapStateToProps)(FLightTimeList)