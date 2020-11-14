import React from "react";
import "./style/form.scss";
import FromField from "./FromField";
import ToField from "./ToField";
import TabSearchExtended from "./TabSearchExtended";
import { Button } from "semantic-ui-react";
import { connect } from "react-redux";
import { GetFlightDirection } from "../../actions/";
import FormatDate from "../../utils/convertdate";


class Form extends React.Component {
    constructor(props) {
        super(props);
        if (!props.flightDirection) {
            props.getFlightDirection();
        }
        this.state = {
            from: null,
            to: null,
            fromid: null,
            toid: null,
            fromdate: null,
            todate: null,
            extend: false,
            isRoundTrip: true
        }
    }
    createOption(fd) {
        if (fd) {
            let options = [];
            for (let key in fd) {
                options.push({
                    key,
                    text: `${fd[key].city} (${key})`,
                    value: key
                });
            }
            return options;
        }
        return null;
    }

    componentDidMount() {
        if (this.props.flightDirection) {
            this.setState({
                from: this.createOption(this.props.flightDirection),
                to: this.createOption(this.props.flightDirection)
            })
        }
    }

    componentDidUpdate(prevProps) {
        if (this.props.flightDirection !== prevProps.flightDirection) {
            this.setState({
                from: this.createOption(this.props.flightDirection),
                to: this.createOption(this.props.flightDirection)
            })
        }
    }

    setData = (cityId, field) => {
        let { flightDirection } = this.props;
        var options = this.createOption(flightDirection[cityId].flightplan)
        let fieldState = field.toLowerCase() === "to" ? "from" : "to";
        this.setState({
            [fieldState]: options,
            [(field + "id").toLowerCase()]: cityId
        }, () => {
            if (this.state.fromid && this.state.toid) {
                this.setState({
                    extend: true
                })
            }
        });
    }

    setTrip = (isRoundTrip) => {
        this.setState({
            isRoundTrip
        })
    }

    setDate = (date, field) => {
        this.setState({
            [field.toLowerCase() + "date"]: date
        });
    }

    handleSearch = evt => {
        let {history, location} = this.props;
        let {fromid, toid, fromdate, todate, isRoundTrip} = this.state;
        let fromdatestr = FormatDate(fromdate);
        let todatestr = todate ? FormatDate(todate) : '';
        if(isRoundTrip) {
            history.push(`/booking/flights?from=${fromid}&to=${toid}&date1=${fromdatestr}&date2=${todatestr}`,
            {
                from: location
            });
        } else {
            history.push(`/booking/flights?from=${fromid}&to=${toid}&date1=${fromdatestr}`,
            {
                from: location
            });
        }
    }
    render() {
        let { from, to, extend, fromdate, todate, fromid, toid, isRoundTrip } = this.state;
        let isDisable = true;
        if(fromid && toid && fromdate) {
            if(isRoundTrip) {
                if(todate) {
                    isDisable = false;
                }
            } else {
                isDisable = false;
            }
        }
        return (
            <div className="tab-searchs">
                <div className="tab-search">
                    <div className="tab-search__form">
                        <div className="tab-search__form-row">
                            <FromField data={from} setData={this.setData} />
                            <ToField data={to} setData={this.setData} />
                        </div>
                        <TabSearchExtended extend={extend} setDate={this.setDate} setTrip={this.setTrip}/>
                    </div>
                    <div className="tab-search__submit">
                        <Button color="green" size="large" disabled={isDisable} onClick={this.handleSearch}>Search flights</Button>
                    </div>
                </div>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        flightDirection: state.FLightDirection
    }
}

const mapDispatchToProps = (dispatch, props) => {
    return {
        getFlightDirection() {
            dispatch(GetFlightDirection())
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(Form);