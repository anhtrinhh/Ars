import React from "react";
import { Table, Button } from "semantic-ui-react";
import { getShortDateStr } from "../../utils/datetime-utils";
import {connect} from "react-redux"
import { setCurrentBooking, setSubStore } from "../../actions";

class BookingItem extends React.Component {
    handleShowModal = evt => {
        this.props.setCurrentBooking(this.props.booking);
        this.props.setOpenModal(true)
    }
    render() {
        let { booking, index } = this.props;
        return (
            <Table.Row>
                <Table.Cell>{index}</Table.Cell>
                <Table.Cell>{booking.bookingId}</Table.Cell>
                <Table.Cell>{booking.customerNo}</Table.Cell>
                <Table.Cell>{booking.numberAdults}</Table.Cell>
                <Table.Cell>{booking.numberChildren}</Table.Cell>
                <Table.Cell>{booking.numberInfants}</Table.Cell>
                <Table.Cell>{booking.totalPrice} $</Table.Cell>
                <Table.Cell>{getShortDateStr(new Date(booking.createdAt))}</Table.Cell>
                <Table.Cell>
                    <Button color="green" size="tiny" onClick={this.handleShowModal}>Detail</Button>
                </Table.Cell>
            </Table.Row>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setOpenModal(isOpen) {
            dispatch(setSubStore({
                openBookingDetailModal: isOpen
            }))
        },
        setCurrentBooking(booking) {
            dispatch(setCurrentBooking(booking))
        }
    }
}

export default connect(null, mapDispatchToProps)(BookingItem)