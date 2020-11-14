import React from "react";
import GuestInfoForm from "../../components/booking/guest-info-form";
import {connect} from "react-redux";

class GuestInfo extends React.Component {
    constructor(props) {
        super(props);
        if(!checkValidate(props.bookingInfo)) {
            props.history.goBack();
        }
    }
    render() {
        const {numberAdults, numberChildren, numberInfants} = this.props.bookingInfo;
        const numberForm = [];
        for(let i = 0; i < numberAdults + numberChildren + numberInfants; i++) {
            if(i < numberAdults) {
                numberForm.push(<GuestInfoForm key={i} index={i} type={1}/>)
            } else if(i >= numberAdults && i < numberAdults + numberChildren) {
                numberForm.push(<GuestInfoForm key={i} index={i} type={2} />)
            } else {
                numberForm.push(<GuestInfoForm key={i} index={i} type={3} />)
            }
        }
        return (
            <div className="flights">
                <div className="flight-header">
                    <p>Who is flying?</p>
                    <span>Your passenger data</span>
                </div>
                <div className="passengers">
                    {numberForm}
                </div>
            </div>
        )
    }
}
function checkValidate(bookingInfo) {
    let success = false;
    if (bookingInfo.numberAdults > 0 && bookingInfo.numberChildren >= 0 && bookingInfo.numberInfants >= 0) {
        if (bookingInfo.flights.length > 0 && bookingInfo.flights.length < 3) {
            let s = true;
            bookingInfo.flights.forEach(val => {
                if(!val.flightId) {
                    s = false
                }
            });
            success = s;
        }
    }
    return success;
}
const mapStateToProps = state => {
    return {
        bookingInfo: state.BookingInfo
    }
}

export default connect(mapStateToProps, null)(GuestInfo);