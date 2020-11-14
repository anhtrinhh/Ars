import React from "react"
import BookingSummary from "../../components/booking/booking-summary";
import GuestSummary from "../../components/booking/guest-summary";
import Card from "../../components/booking/card";
import { connect } from "react-redux"
import ModalBookingSuccess from "../../components/booking/modal-booking-success";
import ModalBookingFail from "../../components/booking/modal-booking-fail";

class Payment extends React.Component {
    constructor(props) {
        super(props);
        if(!checkValidate(props.bookingInfo)) {
            props.history.goBack();
        }
    }
    render() {
        return (
            <div className="flights">
                <div className="flight-header">
                    <p>Payment</p>
                    <span>Choose your payment method.</span>
                </div>
                <div className="passengers">
                    <BookingSummary />
                    <GuestSummary />
                    <Card />
                </div>
                <ModalBookingSuccess {...this.props}/>
                <ModalBookingFail />
            </div>
        )
    }
}

function checkValidate(bookingInfo) {
    let success = true;
    if (bookingInfo.flights[0]) {
        bookingInfo.flights[0].tickets.forEach((val, ix) => {
            if (!val.guestFirstName) {
                success = false;
            }
            if (!val.guestLastName) {
                success = false;
            }
            if (!val.guestBirthday) {
                success = false;
            }
        });
    } else {
        success = false;
    }
    return success;
}

const mapStateToProps = state => {
    return {
        bookingInfo: state.BookingInfo
    }
}

export default connect(mapStateToProps, null)(Payment);