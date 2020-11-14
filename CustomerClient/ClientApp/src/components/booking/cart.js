import React from "react";
import { Icon } from "semantic-ui-react";
import { connect } from "react-redux";
import FormatDate, { GetTimeStr } from "../../utils/convertdate"
import { SetOpenModalBookingDetail, SetFlightIndex } from "../../actions";

class Cart extends React.Component {
    handleOpenBookingDetail = ix => {
        this.props.setOpenModal(true);
        this.props.setFlightIndex(ix);
    }
    render() {
        const { flightDirection, cart, bookingInfo } = this.props;
        let prices = getTicketPrice(bookingInfo.flights, bookingInfo.numberAdults, bookingInfo.numberChildren);
        return (
            <div className="cart">
                <div className="cart-header">
                    <h3>Payment details</h3>
                </div>
                <div className="cart-body">
                    <div className="flight-title">
                        <b>{flightDirection[cart.startPointId]
                            ? flightDirection[cart.startPointId].city : ''} ({cart.startPointId})</b>
                        <Icon name="arrow right" />
                        <b>{flightDirection[cart.endPointId]
                            ? flightDirection[cart.endPointId].city : ''} ({cart.endPointId})</b>
                    </div>
                    <div>
                        {
                            bookingInfo.flights.map((val, ix) =>
                                val.flightId ? (
                                    <div className="flight-selected" key={ix}>
                                        <div>
                                            <p>
                                                <b>{val.startPointId} to {val.endPointId}: </b>
                                                <span>{val.flightId}</span>
                                            </p>
                                            <p className="time">{GetTimeStr(val.startTime)} - {FormatDate(new Date(val.flightDate))}</p>
                                            <p className={"ticket-class " + val.ticketClassId.toLowerCase()}>{val.ticketClass}</p>
                                        </div>
                                        <div>
                                            <button
                                                onClick={evt => this.handleOpenBookingDetail(ix)}
                                            >Detail</button>
                                        </div>
                                    </div>) : ''
                            )
                        }
                    </div>
                    {
                        bookingInfo.flights[0] && (bookingInfo.flights[0].flightId ? (
                            <div className="pay">
                                <p className="pay-title"><b>Payment details:</b></p>
                                <div className="pay-item">
                                    <span>{bookingInfo.numberAdults} adults: </span>
                                    <span>{prices[0]}$</span>
                                </div>
                                {bookingInfo.numberChildren ? (
                                    <div className="pay-item">
                                        <span>{bookingInfo.numberChildren} children: </span>
                                        <span>{prices[1]}$</span>
                                    </div>
                                ) : ''}
                                {bookingInfo.numberInfants ? (
                                    <div className="pay-item">
                                        <span>{bookingInfo.numberInfants} infants: </span>
                                        <span>{prices[2]}$</span>
                                    </div>
                                ) : ''}
                                <div className="pay-item">
                                    <span>VAT: </span>
                                    <span>{prices[3]}$</span>
                                </div>
                                <div className="total">
                                    <span>Total: </span>
                                    <span>{
                                        bookingInfo.flights.reduce((t, v) => {
                                            return t + v.totalTex + v.totalTicketPrice
                                        }, 0)
                                    }$</span>
                                </div>
                            </div>
                        ) : '')
                    }
                </div>
            </div>
        )
    }
}

function getTicketPrice(flights, numberAdults, numberChildren) {
    let prices = [0, 0, 0, 0]
    flights.forEach(val => {
        if (val.flightId) {
            val.tickets.forEach((t, ix) => {
                if (ix < numberAdults) {
                    prices[0] += t.ticketPrice;
                } else if (ix >= numberAdults && ix < numberAdults + numberChildren) {
                    prices[1] += t.ticketPrice;
                } else {
                    prices[2] += t.ticketPrice;
                }
            })
        }
        prices[3] += val.totalTex;
    });
    return prices;
}

const mapStateToProps = state => {
    return {
        bookingInfo: state.BookingInfo,
        cart: state.Cart,
        flightDirection: state.FLightDirection
    }
}
const mapDispatchToProps = dispatch => {
    return {
        setOpenModal(isOpenModal) {
            dispatch(SetOpenModalBookingDetail(isOpenModal))
        },
        setFlightIndex(ix) {
            dispatch(SetFlightIndex(ix))
        }
    }
}
export default connect(mapStateToProps, mapDispatchToProps)(Cart);