import React from "react"
import BookFare from "./book-fare";
import { GetTimeStr, SubtractTime } from "../../utils/convertdate";

class FlightItem extends React.Component {
    render() {
        let { index, flight } = this.props;
        return (
            <div className="flight">
                <div className="select-flight">
                    <div className="times">
                        <div className="time">
                            <div className="point-time">
                                <span>{GetTimeStr(flight.startTime)}</span>
                                <span>{flight.startPointId}</span>
                            </div>
                            <div className="duration">
                                <span className="label">{SubtractTime(flight.endTime, flight.startTime)}</span>
                                <span className="flight-number">{flight.flightId}</span>
                            </div>
                            <div className="point-time">
                                <span>{GetTimeStr(flight.endTime)}</span>
                                <span>{flight.endPointId}</span>
                            </div>
                        </div>
                    </div>
                    <div className="book">
                        <div className="book-inner">
                            {flight.ticketClassDetail
                                ? flight.ticketClassDetail.map((val, ix) =>
                                    <BookFare index={index} key={ix} ticketClass={val} flight={flight} />)
                                : ''}
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}

export default FlightItem;