import React from "react"
import { Form } from "semantic-ui-react";
import FlightDate from "./flight-date";
import FilterFlight from "./form-filter-flight";
import FlightTimeSlot from "./flight-slottime"
import {getTimeSlot1}  from "../../actions";
import {connect} from "react-redux";
import {getShortDateStr} from "../../utils/datetime-utils"

class BasicInfo extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            date: null,
            fromid: null,
            toid: null,
            flightid: null,
            time: null
        }
    }
    setDate = (date) => {
        this.setState({
            date: date
        });
    }
    handleChangeText = evt => {
        this.setState({
            flightid: evt.target.value
        }, this.getTimeSlot)
    }
    handleChangeFilter = (fromid, toid) => {
        this.setState({
            fromid,
            toid
        }, this.getTimeSlot)
    }
    getTimeSlot = () => {
        let {date, fromid, toid} = this.state;
        date = getShortDateStr(date);
        let {token} = this.props;
        if(date && fromid && toid) {
            this.props.getTimeSlot(fromid, toid, date, token);
        }
    }
    render() {
        let {date} = this.state;
        return (
            <div className="row">
                <div className="col-10">
                    <Form>
                        <Form.Group widths="equal">
                            <Form.Field>
                                <label>Flight code</label>
                                <input type="text" placeholder="Flight code" onChange={this.handleChangeText}/>
                            </Form.Field>
                            <Form.Field>
                                <label>Flight date</label>
                                <FlightDate setDate={this.setDate} selected={date} />
                            </Form.Field>
                        </Form.Group>
                    </Form>
                </div>
                <div className="col-10">
                    <FilterFlight onChangeValue={this.handleChangeFilter} />
                </div>
                <div className="col-5">
                    <FlightTimeSlot />
                </div>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        token: state.account.jwtToken
    }
}

const mapDispatchToProps = dispatch => {
    return {
        getTimeSlot(fromid, toid, date, token) {
            dispatch(getTimeSlot1(fromid, toid, date, token))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(BasicInfo);