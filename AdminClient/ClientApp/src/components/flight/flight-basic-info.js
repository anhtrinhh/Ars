import React from "react"
import { Form, TextArea, Button } from "semantic-ui-react";
import FlightDate from "./flight-date";
import FilterFlight from "./form-filter-flight";
import FlightTimeSlot from "./flight-slottime"
import { getTimeSlot1, setFlightBasicInfo } from "../../actions";
import { connect } from "react-redux";
import { getShortDateStr } from "../../utils/datetime-utils"

class BasicInfo extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            date: props.basicInfo.date,
            fromid: props.basicInfo.fromid,
            toid: props.basicInfo.toid,
            flightid: props.basicInfo.flightid,
            time: props.basicInfo.time,
            note: props.basicInfo.note
        }
    }
    setDate = (date) => {
        this.setState({
            date: date
        }, this.getTimeSlot);
    }
    handleChangeText = evt => {
        this.setState({
            flightid: evt.target.value
        })
    }
    handleChangeFilter = (fromid, toid) => {
        this.setState({
            fromid,
            toid
        }, this.getTimeSlot)
    }
    getTimeSlot = () => {
        let { date, fromid, toid } = this.state;
        date = getShortDateStr(date);
        let { token } = this.props;
        if (date && fromid && toid) {
            this.props.getTimeSlot(fromid, toid, date, token);
        }
    }
    handleChangeTimeslot = data => {
        this.setState({
            time: data
        })
    }
    handleChangeNote = (evt, data) => {
        this.setState({
            note: data.value
        })
    }
    handleSubmit = () => {
        let { date, flightid, fromid, toid, time } = this.state;
        if (date && flightid.trim() && toid && fromid && time) {
            this.props.setBasicInfo(this.state);
            this.props.history.push("2", {
                from: this.props.location
            })
        }
    }
    render() {
        let { date, flightid, fromid, toid, time, note } = this.state;
        let isDisable = (date && flightid.trim() && toid && fromid && time) ? false : true;
        return (
            <React.Fragment>
                <h4>Basic information</h4>
                <div className="row">
                    <div className="col-10">
                        <Form>
                            <Form.Group widths="equal">
                                <Form.Field>
                                    <label>Flight code</label>
                                    <input type="text"
                                        placeholder="Flight code"
                                        onChange={this.handleChangeText}
                                        value={flightid}
                                    />
                                </Form.Field>
                                <Form.Field>
                                    <label>Flight date</label>
                                    <FlightDate setDate={this.setDate} selected={date} />
                                </Form.Field>
                            </Form.Group>
                        </Form>
                    </div>
                    <div className="col-10">
                        <FilterFlight
                            onChangeValue={this.handleChangeFilter}
                            selectedFrom={fromid}
                            selectedTo={toid}
                        />
                    </div>
                    <div className="col-5">
                        <FlightTimeSlot
                            onChangeTimeslot={this.handleChangeTimeslot}
                            selected={time ? JSON.stringify(time) : null}
                        />
                    </div>
                    <div className="col-10">
                        <Form>
                            <Form.Field>
                                <label>Flight note</label>
                                <TextArea placeholder="Flight note..." style={{ minHeight: 100 }}
                                    onChange={this.handleChangeNote}
                                    value={note}
                                />
                            </Form.Field>
                        </Form>
                    </div>
                    <div className="col-10 mt-3 d-flex justify-content-center">
                        <Button color="green"
                            disabled={isDisable}
                            size="large"
                            onClick={this.handleSubmit}
                            style={{ width: 200 }}>Next</Button>
                    </div>
                </div>
            </React.Fragment>
        )
    }
}

const mapStateToProps = state => {
    return {
        token: state.account.jwtToken,
        basicInfo: state.flightBasicInfo
    }
}

const mapDispatchToProps = dispatch => {
    return {
        getTimeSlot(fromid, toid, date, token) {
            dispatch(getTimeSlot1(fromid, toid, date, token))
        },
        setBasicInfo(basicInfo) {
            dispatch(setFlightBasicInfo(basicInfo))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(BasicInfo);