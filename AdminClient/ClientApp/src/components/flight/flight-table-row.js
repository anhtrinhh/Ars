import React from "react"
import { Link } from "react-router-dom";
import { Table, Label, Button, Checkbox } from "semantic-ui-react";
import { getMediumTimeStr, subtractTime } from "../../utils/datetime-utils";
import {getShortDateStr} from "../../utils/datetime-utils"
import {connect} from "react-redux";
import { updateFlightStatus } from "../../actions";

class FlightTableRow extends React.Component {
    constructor(props) {
        super(props);
        let {flight} = props;
        this.state = {
            flightId: flight.flightId,
            startTime: flight.startTime,
            endTime: flight.endTime,
            flightStatus: flight.flightStatus,
            flightNote: flight.flightNote,
        }
    }
    handleChangeStatus = (evt, data) => {
        let confirm = window.confirm('Do you want to change flight status?');
        if(confirm) {
            this.props.updateStatus(data.checked, this.state.flightId);
            this.setState({
                flightStatus: data.checked
            })
        }
    }
    render() {
        let { index, flightDate } = this.props;
        let {flightId, startTime, endTime, flightStatus, flightNote} = this.state;
        let isToday = getShortDateStr(new Date()) === flightDate;
        return (
            <Table.Row className>
                <Table.Cell>{index}</Table.Cell>
                <Table.Cell>{flightId}</Table.Cell>
                <Table.Cell>{getMediumTimeStr(startTime)}</Table.Cell>
                <Table.Cell>{getMediumTimeStr(endTime)}</Table.Cell>
                <Table.Cell>{subtractTime(endTime, startTime)}</Table.Cell>
                <Table.Cell>
                    {flightStatus
                        ? <Label color="green" style={{ cursor: "pointer" }}>Departed</Label>
                        : <Label style={{ cursor: "pointer" }}>Not departed</Label>}
                </Table.Cell>
                <Table.Cell>{flightNote}</Table.Cell>
                <Table.Cell>
                    <Link to={`/flight-management/detail/${flightId}`}>
                        <Button color="green" size="mini">Detail</Button>
                    </Link>
                    <Link to={`/flight-management/bookings/${flightId}`}>
                        <Button color="yellow" size="mini" className="mt-2">Bookings</Button>
                    </Link>
                </Table.Cell>
                {
                    isToday && <Table.Cell>
                        <Checkbox toggle 
                        checked={flightStatus} 
                        onChange={this.handleChangeStatus}
                        />
                        </Table.Cell>
                }
            </Table.Row>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return {
        updateStatus(flightStatus, flightId) {
            dispatch(updateFlightStatus(flightStatus, flightId))
        }
    }
}

export default connect(null, mapDispatchToProps)(FlightTableRow);