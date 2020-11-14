import "./style/style.scss";
import { SearchIcon } from "../../icons";
import React from "react";
import Form from "./Form";
import { connect } from "react-redux";
import {ClearBookingInfo} from "../../actions";

class BookingMask extends React.Component {
    componentDidMount() {
        this.props.clearBookingInfo();
    }
    render() {
        return (
            <div className="booking-mask">
                <div className="tab-head">
                    <h3 className="booking-title">
                        <span>
                            <SearchIcon />
                        </span>
                    Search flights
                </h3>
                </div>
                <Form {...this.props} />
            </div>
        )
    }
}

const mapDispatchToProps = (dispatch, props) => {
    return {
        clearBookingInfo() {
            dispatch(ClearBookingInfo())
        }
    }
}

export default connect(null, mapDispatchToProps)(BookingMask);