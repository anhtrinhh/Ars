import React from "react";
import { Grid } from "semantic-ui-react";
import { connect } from "react-redux";
import { GetDateStr, GetTimeStr, SubtractTime } from "../../utils/convertdate";

class BookingSummary extends React.Component {
    render() {
        let { bookingInfo } = this.props;
        return (
            <div className="form-wrapper">
                <h3>Flights</h3>
                <Grid>
                    <Grid.Row>
                        {bookingInfo.flights.map((val, ix) => (
                            <Grid.Column mobile={16} tablet={8} computer={8} key={ix}>
                                <div className="summary-flight">
                                    <h4>Flight: {GetDateStr(val.flightDate)}</h4>
                                    <p>
                                        <b>{GetTimeStr(val.startTime)}</b>
                                        <span>{val.startPointId}</span>
                                    </p>
                                    <p>
                                        <b>{GetTimeStr(val.endTime)}</b>
                                        <span>{val.endPointId}</span>
                                    </p>
                                    <p>
                                        <b></b>
                                        <span>{val.flightId}</span>
                                    </p>
                                    <p>
                                        <b>Travel time:</b>
                                        <span>{SubtractTime(val.endTime, val.startTime)}</span>
                                    </p>
                                    <h4>Selected fare: {val.ticketClass}</h4>
                                </div>
                            </Grid.Column>
                        ))}
                    </Grid.Row>
                </Grid>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        bookingInfo: state.BookingInfo
    }
}

export default connect(mapStateToProps, null)(BookingSummary);