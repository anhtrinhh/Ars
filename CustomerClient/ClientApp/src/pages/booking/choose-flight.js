import React from "react";
import FlightList from "../../components/booking/flight-list";
import FormatString from "../../utils/format-string";
import { Redirect } from "react-router-dom";
import ApiCaller from "../../utils/apicaller";
import FormatDate from "../../utils/convertdate";
import {connect} from "react-redux";
import {SetInitFlight, GetFlightDirection, SetCart, SetLoader} from "../../actions";

class ChooseFlight extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            data: [null]
        }
    }
    componentDidMount() {
        const params = new URLSearchParams(this.props.location.search);
        const from = FormatString(params.get("from"));
        const to = FormatString(params.get("to"));
        const date1 = FormatString(params.get("date1"));
        const date2 = FormatString(params.get("date2"));
        if(from && to && isValidDate(date1)) {
            let endpoint = `flight/search?from=${from}&to=${to}&date1=${date1}`
            + (isValidDate(date2) ? `&date2=${date2}` : '');
            this.props.setLoader(true);
            ApiCaller(endpoint).then(res => {
                this.setState({
                    data: res.data
                });
                this.props.setInitFlight(res.data.length);
                this.props.setLoader(false);
            }).catch(err => {
                console.log(err);
                this.props.history.replace("/");
                this.setLoader(false);
            });
            this.props.setCart(from, to);
        }
        if(!this.props.flightDirection) {
            this.props.getFlightDirection();
        }
    }
    render() {
        const { data } = this.state;
        const { location } = this.props;
        const params = new URLSearchParams(this.props.location.search);
        const from = FormatString(params.get("from"));
        const to = FormatString(params.get("to"));
        const date1 = FormatString(params.get("date1"));
        return (from && to && isValidDate(date1)) ? (
            <React.Fragment>
                {
                    data.map((val, ix) => <FlightList key={ix} index={ix} flightList={val} {...this.props} />)
                }
            </React.Fragment>) : <Redirect to={location.state ? location.state.from : "/"} />
    }
}

function isValidDate(dateString) {
    var regEx = /^\d{4}-\d{2}-\d{2}$/;
    if (!regEx.test(dateString)) return false;
    var d = new Date(dateString);
    var dNum = d.getTime();
    if (!dNum && dNum !== 0) return false;
    return FormatDate(d) === dateString;
}

const mapDispatchToProps = (dispatch, props) => {
    return {
        setInitFlight(amount) {
            dispatch(SetInitFlight(amount))
        },
        getFlightDirection() {
            dispatch(GetFlightDirection())
        },
        setCart(startPointId, endPointId) {
            dispatch(SetCart(startPointId, endPointId))
        },
        setLoader(loaderState) {
            dispatch(SetLoader(loaderState))
        }
    }
}

const mapStateToProps = state => {
    return {
        flightDirection: state.FlightDirection
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(ChooseFlight);