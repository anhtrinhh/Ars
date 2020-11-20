import React from "react";
import { Modal, Button, Icon, Grid, Table } from "semantic-ui-react";
import { connect } from "react-redux";
import { setSubStore } from "../../actions";
import {getShortDateStr, getShortTimeStr} from "../../utils/datetime-utils"

class BookingDetailModal extends React.Component {
    handleClose = evt => {
        this.props.setOpenModal(false)
    }
    render() {
        let { currentBooking, openBookingDetailModal, flightDirection } = this.props;
        return (
            <Modal open={openBookingDetailModal} size="small" onClose={this.handleClose}>
                { currentBooking ? (<React.Fragment>
                    <Modal.Header>
                        {flightDirection[currentBooking.flight.startPointId].city} ({getShortTimeStr(currentBooking.flight.startTime)})
                    <Icon name="arrow right" />
                        {flightDirection[currentBooking.flight.endPointId].city} ({getShortTimeStr(currentBooking.flight.endTime)})
                    </Modal.Header>
                    <Modal.Content>
                        <Grid className="pl-3">
                            <Grid.Row>
                                <Grid.Column computer="4"><h4>Number of adults:</h4></Grid.Column>
                                <Grid.Column computer="12">{currentBooking.numberAdults}</Grid.Column>
                                <Grid.Column computer="4"><h4>Number of children:</h4></Grid.Column>
                                <Grid.Column computer="12">{currentBooking.numberChildren}</Grid.Column>
                                <Grid.Column computer="4"><h4>Number of infants:</h4></Grid.Column>
                                <Grid.Column computer="12">{currentBooking.numberInfants}</Grid.Column>
                                <Grid.Column computer="4"><h4>Total fare:</h4></Grid.Column>
                                <Grid.Column computer="12">{currentBooking.totalTicketPrice} $</Grid.Column>
                                <Grid.Column computer="4"><h4>VAT:</h4></Grid.Column>
                                <Grid.Column computer="12">{currentBooking.totalTex} $</Grid.Column>
                            </Grid.Row>
                        </Grid>
                        <h3>List of customers</h3>
                        <Table celled>
                            <Table.Header>
                                <Table.Row>
                                    <Table.HeaderCell>No</Table.HeaderCell>
                                    <Table.HeaderCell>Customer name</Table.HeaderCell>
                                    <Table.HeaderCell>Customer gender</Table.HeaderCell>
                                    <Table.HeaderCell>Date of birth</Table.HeaderCell>
                                    <Table.HeaderCell>Ticket price</Table.HeaderCell>
                                </Table.Row>
                            </Table.Header>
                            <Table.Body>
                                {currentBooking.ticket.map((val, ix) => (
                                    <Table.Row key={ix}>
                                        <Table.Cell>{ix + 1}</Table.Cell>
                                        <Table.Cell>{val.guestFirstName + ' ' + val.guestLastName}</Table.Cell>
                                        <Table.Cell>{val.guestGender ? 'Female' : 'Male'}</Table.Cell>
                                        <Table.Cell>{getShortDateStr(new Date(val.guestBirthday))}</Table.Cell>
                                        <Table.Cell>{val.ticketPrice} $</Table.Cell>
                                    </Table.Row>
                                ))}
                            </Table.Body>
                        </Table>
                    </Modal.Content>
                    <Modal.Actions>
                        <Button positive onClick={this.handleClose}>Close</Button>
                    </Modal.Actions>
                </React.Fragment>) : ''}
            </Modal>
        )
    }
}

let mapStateToProps = state => {
    return {
        openBookingDetailModal: state.subStore.openBookingDetailModal,
        currentBooking: state.currentBooking,
        flightDirection: state.flightDirection
    }
}

let mapDispatchToProps = dispatch => {
    return {
        setOpenModal(isOpen) {
            dispatch(setSubStore({
                openBookingDetailModal: isOpen
            }));
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(BookingDetailModal);