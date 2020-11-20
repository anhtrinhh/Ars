import React from "react";
import BookingList from "../../components/booking/booking-list"
import BookingDetailModal from "../../components/booking/booking-detail-modal"
import {connect} from "react-redux";
import { getBookingByFlightId } from "../../actions";

class Booking extends React.Component {
    componentDidMount() {
        let {flightId} = this.props.match.params;
        this.props.getBookings(flightId);
    }
    render() {
        return (
            <div className="content-wrapper">
                <div className="content-header">
                    <div className="container-fluid">
                        <div className="row mb-2">
                            <div className="col-12">
                                <h3>All bookings</h3>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="content">
                    <div className="container-fluid">
                        <BookingList />
                        <BookingDetailModal />
                    </div>
                </div>
            </div>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return {
        getBookings(flightId) {
            dispatch(getBookingByFlightId(flightId))
        }
    }
}

export default connect(null, mapDispatchToProps)(Booking);