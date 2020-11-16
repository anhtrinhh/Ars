import React from "react";
import { connect } from "react-redux";
import { searchFlight } from "../../actions"
import { isValidDate, getLongDateStr } from "../../utils/datetime-utils";
import { Icon } from "semantic-ui-react";
import FlightTable from "../../components/flight/flight-table";

class FlightSearch extends React.Component {
    componentDidMount() {
        let { from, to, flightDate } = this.props.match.params;
        if (from && to && isValidDate(flightDate)) {
            this.props.getFlights(from.toUpperCase(), to.toUpperCase(), flightDate);
        } else {
            this.props.history.goBack();
        }
    }
    render() {
        let { from, to, flightDate } = this.props.match.params;
        from = from.toUpperCase();
        to = to.toUpperCase();
        let { flightDirection } = this.props;
        let city1 = flightDirection[from] ? flightDirection[from].city : from;
        let city2 = flightDirection[to] ? flightDirection[to].city : to;
        return (
            <div className="content-wrapper">
                <div className="content-header">
                    <div className="container-fluid">
                        <div className="row mb-2">
                            <div className="col-12">
                                <h3>{city1} <Icon name="arrow right" /> {city2}</h3>
                                <h4>{getLongDateStr(new Date(flightDate))}</h4>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="content">
                    <div className="container-fluid">
                        <FlightTable />
                    </div>
                </div>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        flightDirection: state.flightDirection
    }
}

const mapDispatchToProps = dispatch => {
    return {
        getFlights(from, to, flightDate) {
            dispatch(searchFlight(from, to, flightDate))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(FlightSearch);