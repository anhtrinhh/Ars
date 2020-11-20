import React from "react"
import { Table } from "semantic-ui-react";
import "./style.scss";
import { connect } from "react-redux";
import BookingItem from "./booking-item"

class BookingList extends React.Component {
    render() {
        let { currentBookings, flightDirection } = this.props;
        return (
            <div className="row">
                <div className="col-10">
        <h4>{currentBookings[0] 
        ? `${flightDirection[currentBookings[0].flight.startPointId].city} to ${flightDirection[currentBookings[0].flight.endPointId].city}` 
        : ''}</h4>
                </div>
                <div className="col-10">
                    <Table celled className="booking-list">
                        <Table.Header>
                            <Table.Row>
                                <Table.HeaderCell width="1">No</Table.HeaderCell>
                                <Table.HeaderCell width="2">Booking code</Table.HeaderCell>
                                <Table.HeaderCell width="2">Customer code</Table.HeaderCell>
                                <Table.HeaderCell width="1">Number of adults</Table.HeaderCell>
                                <Table.HeaderCell width="1">Number of children</Table.HeaderCell>
                                <Table.HeaderCell width="1">Number of infants</Table.HeaderCell>
                                <Table.HeaderCell width="2">Total price</Table.HeaderCell>
                                <Table.HeaderCell width="2">Created at</Table.HeaderCell>
                                <Table.HeaderCell width="2"></Table.HeaderCell>
                            </Table.Row>
                        </Table.Header>
                        {(currentBookings.length) > 0 && (<Table.Body>
                            {currentBookings.map((val, ix) => (
                                <BookingItem index={ix + 1} booking={val} key={ix} />
                            ))}
                        </Table.Body>)}
                    </Table>
                    {(currentBookings.length === 0) && (<h4 className="text-danger">No data available in table!</h4>)}
                </div>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        currentBookings: state.currentBookings,
        flightDirection: state.flightDirection
    }
}

export default connect(mapStateToProps)(BookingList);