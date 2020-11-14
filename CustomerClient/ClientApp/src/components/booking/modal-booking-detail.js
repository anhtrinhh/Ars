import React from "react";
import { Grid, Button, Modal } from "semantic-ui-react";
import { connect } from "react-redux"
import { SetOpenModalBookingDetail } from "../../actions";
import { GetTimeStr, SubtractTime, GetDateStr } from "../../utils/convertdate";

class ModalBookingDetail extends React.Component {
    handleClose = evt => {
        this.props.setOpenModal(false)
    }
    render() {
        let flight = this.props.flights[this.props.subStore.flightIndex];
        let { numberAdults, numberChildren, numberInfants } = this.props;
        let guests = [];
        if(flight) {
            if (flight.flightId) {
                for (let i = 0; i < numberAdults + numberChildren + numberInfants; i++) {
                    if (i < numberAdults) {
                        guests.push(<Grid.Row key={i} >
                            <Grid.Column mobile={16} tablet={8} computer={8}>
                                <p>Fare (adults)</p>
                            </Grid.Column>
                            <Grid.Column mobile={16} tablet={8} computer={8}>
                                <p><b>{flight.tickets[i].ticketPrice} $</b></p>
                            </Grid.Column>
                        </Grid.Row>);
                    } else if (i >= numberAdults && i < numberAdults + numberChildren) {
                        guests.push(<Grid.Row key={i} >
                            <Grid.Column mobile={16} tablet={8} computer={8}>
                                <p>Fare (children)</p>
                            </Grid.Column>
                            <Grid.Column mobile={16} tablet={8} computer={8}>
                                <p><b>{flight.tickets[i].ticketPrice} $</b></p>
                            </Grid.Column>
                        </Grid.Row>);
                    } else {
                        guests.push(<Grid.Row key={i} >
                            <Grid.Column mobile={16} tablet={8} computer={8}>
                                <p>Fare (infants)</p>
                            </Grid.Column>
                            <Grid.Column mobile={16} tablet={8} computer={8}>
                                <p><b>{flight.tickets[i].ticketPrice} $</b></p>
                            </Grid.Column>
                        </Grid.Row>);
                    }
                }
            }
        }
        return flight ? (flight.flightId ? (
            <Modal open={this.props.subStore.isOpenModalBookingDetail} size="tiny" onClose={this.handleClose}>
                <Modal.Header>{GetDateStr(flight.flightDate)}</Modal.Header>
                <Modal.Content>
                    <div className="booking-detail-header">
                        <div className="time">
                            <p><b>{GetTimeStr(flight.startTime)}</b></p>
                            <p>{flight.startPointId}</p>
                        </div>
                        <div className="duration">
                            <p>{SubtractTime(flight.endTime, flight.startTime)}</p>
                            <p>{flight.flightId}</p>
                        </div>
                        <div className="time">
                            <p><b>{GetTimeStr(flight.endTime)}</b></p>
                            <p>{flight.endPointId}</p>
                        </div>
                    </div>
                    <div className="booking-detail-body">
                        <Grid>
                            {guests}
                            <Grid.Row>
                                <Grid.Column mobile={16} tablet={8} computer={8}>
                                    <h4>Total tex</h4>
                                </Grid.Column>
                                <Grid.Column mobile={16} tablet={8} computer={8}>
                                    <h4>{flight.totalTex} $</h4>
                                </Grid.Column>
                            </Grid.Row>
                            <Grid.Row>
                                <Grid.Column mobile={16} tablet={8} computer={8}>
                                    <h3>Total</h3>
                                </Grid.Column>
                                <Grid.Column mobile={16} tablet={8} computer={8}>
                                    <h3>{flight.totalTex + flight.totalTicketPrice} $</h3>
                                </Grid.Column>
                            </Grid.Row>
                        </Grid>
                    </div>
                </Modal.Content>
                <Modal.Actions>
                    <Button positive onClick={this.handleClose}>Close</Button>
                </Modal.Actions>
            </Modal>
        ) : <span></span>) : <span></span>
    }
}

const mapStateToProps = state => {
    return {
        subStore: state.SubStore,
        flights: state.BookingInfo.flights,
        numberAdults: state.BookingInfo.numberAdults,
        numberChildren: state.BookingInfo.numberChildren,
        numberInfants: state.BookingInfo.numberInfants
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setOpenModal(isOpenModal) {
            dispatch(SetOpenModalBookingDetail(isOpenModal))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(ModalBookingDetail);