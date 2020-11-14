import React from "react";
import { Modal, Button, Icon, Grid, Table } from "semantic-ui-react";
import { connect } from "react-redux";
import { SetBookingDetailModal } from "../../actions";
import FormatDate, { GetTimeStr } from "../../utils/convertdate"

class BookingModal extends React.Component {
    handleClose = evt => {
        this.props.setOpenModal(false)
    }
    render() {
        let { flight, isOpenModal, flightDirection } = this.props;
        return (
            <Modal open={isOpenModal} size="small" onClose={this.handleClose}>
                { flight ? (<React.Fragment>
                    <Modal.Header>
                        {flightDirection[flight.flight.startPointId].city} ({GetTimeStr(flight.flight.startTime)})
                    <Icon name="arrow right" />
                        {flightDirection[flight.flight.endPointId].city} ({GetTimeStr(flight.flight.endTime)})
                    </Modal.Header>
                    <Modal.Content>
                        <Grid>
                            <Grid.Row>
                                <Grid.Column computer="4"><h4>Number of adults:</h4></Grid.Column>
                                <Grid.Column computer="12">{flight.numberAdults}</Grid.Column>
                                <Grid.Column computer="4"><h4>Number of children:</h4></Grid.Column>
                                <Grid.Column computer="12">{flight.numberChildren}</Grid.Column>
                                <Grid.Column computer="4"><h4>Number of infants:</h4></Grid.Column>
                                <Grid.Column computer="12">{flight.numberInfants}</Grid.Column>
                                <Grid.Column computer="4"><h4>Total fare:</h4></Grid.Column>
                                <Grid.Column computer="12">{flight.totalTicketPrice} $</Grid.Column>
                                <Grid.Column computer="4"><h4>VAT:</h4></Grid.Column>
                                <Grid.Column computer="12">{flight.totalTex} $</Grid.Column>
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
                                {flight.ticket.map((val, ix) => (
                                    <Table.Row key={ix}>
                                        <Table.Cell>{ix + 1}</Table.Cell>
                                        <Table.Cell>{val.guestFirstName + ' ' + val.guestLastName}</Table.Cell>
                                        <Table.Cell>{val.guestGender ? 'Female' : 'Male'}</Table.Cell>
                                        <Table.Cell>{FormatDate(new Date(val.guestBirthday))}</Table.Cell>
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
        isOpenModal: state.SubStore.isOpenBookingDetailModal,
        flight: state.Flight.currentFlight,
        flightDirection: state.FLightDirection
    }
}

let mapDispatchToProps = dispatch => {
    return {
        setOpenModal(isOpen) {
            dispatch(SetBookingDetailModal(isOpen));
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(BookingModal);