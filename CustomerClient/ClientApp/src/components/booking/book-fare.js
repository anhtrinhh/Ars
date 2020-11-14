import React from "react";
import { connect } from "react-redux";
import { SetTicket } from "../../actions";

class BookFare extends React.Component {
    constructor(props) {
        super(props);
        this.radio = React.createRef();
    }
    handleChoose = evt => {
        if (this.radio.current) {
            this.radio.current.click();
            this.props.setTicket(this.props.flight, this.props.ticketClass, this.props.index);
        }
    }
    render() {
        let { index, ticketClass, totalGuest } = this.props;
        return (
            <div
                className={"book-fare " + (ticketClass.ticketClassId.toLowerCase())}
                onClick={this.handleChoose}
            >
                {(totalGuest <= ticketClass.numberTicket)
                    ? (<label className="control radio">
                        <input type="radio" name={"ticketclass_" + index} ref={this.radio} />
                        <span className="control-indicator"></span>
                    </label>)
                    : ''}
                <div className="book-class">
                    <span>Ars {(ticketClass.ticketClassId.toLowerCase() === "eco")
                        ? "Economy"
                        : (ticketClass.ticketClassId.toLowerCase() === "pre")
                            ? "Premium"
                            : "Business"}</span>
                </div>
                <div className="book-meta">
                    {(ticketClass.numberTicket > 0)
                        ? <span>{ticketClass.adultTicketPrice} $</span>
                        : <span>SOLD OUT</span>}
                </div>
                <div className="seats-left best-price-seats-left">
                    {(ticketClass.numberTicket > 0)
                        ? <span className="xq-hide">There are {ticketClass.numberTicket} tickets at this price</span>
                        : ''}
                </div>
            </div>
        )
    }
}

const mapDispatchToProps = (dispatch, props) => {
    return {
        setTicket(flight, ticketClassDetail, index) {
            dispatch(SetTicket(flight, ticketClassDetail, index))
        }
    }
}
const mapStateToProps = state => {
    const bookingInfo =  state.BookingInfo;
    return {
        totalGuest: bookingInfo.numberAdults + bookingInfo.numberChildren + bookingInfo.numberInfants
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(BookFare);