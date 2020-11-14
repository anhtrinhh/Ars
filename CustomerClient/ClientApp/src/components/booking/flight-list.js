import React from "react";
import FlightItem from "./flight-item"
import {connect} from "react-redux";
import {GetDateStr} from "../../utils/convertdate";

class FlightList extends React.Component {
    render() {
        let { index, flightList, location, flightDirection } = this.props;
        let searchParams = new URLSearchParams(location.search);
        let datestr = index ? searchParams.get("date2") : searchParams.get("date1");
        let {to, from} = getToFrom(flightDirection, searchParams.get("from"), searchParams.get("to"), index);
        return (
            <div className="flights">
                <div className="flight-header">
                    <p>Choose your flight</p>
                    <span><b>{from}</b> to <b>{to}</b></span>
                </div>
                <div className="date">
                    {GetDateStr(datestr)}
                </div>
                <div className="ticket-classes">
                    <div className="eco">
                        <span>Ars Economy</span>
                    </div>
                    <div className="pre">
                        <span>Ars Premium</span>
                    </div>
                    <div className="bus">
                        <span>Ars Bussiness</span>
                    </div>
                </div>
                <div className="flight-section">
                    {flightList
                        ? flightList.map((val, ix) => <FlightItem key={ix} index={index} flight={val} />)
                        : <div className="flight">
                            <div className="flight-notfound">
                                <span>No flights Available!</span>
                            </div>
                        </div>}
                </div>
            </div>
        )
    }
}

function getToFrom(flightDirection, cityId1, cityId2, index) {
    let to = '';
    let from = '';
    cityId1 = cityId1.toUpperCase();
    cityId2 = cityId2.toUpperCase();
    if(index) {
        if(flightDirection && flightDirection[cityId1] && flightDirection[cityId2]) {
            to = flightDirection[cityId1].city;
            from = flightDirection[cityId2].city;
        } else {
            to = cityId1;
            from = cityId2;;
        }
    } else  {
        if(flightDirection && flightDirection[cityId1] && flightDirection[cityId2]) {
            from = flightDirection[cityId1].city;
            to = flightDirection[cityId2].city;
        } else {
            from = cityId1;
            to = cityId2;;
        }
    }
    return {to ,from}
}

const mapStateToProps = state => {
    return {
        flightDirection: state.FLightDirection
    }
}

export default connect(mapStateToProps, null)(FlightList);