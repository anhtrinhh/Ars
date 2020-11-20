import React from "react"
import { Table, Button } from "semantic-ui-react"
import { getShortTimeStr, subtractTime } from "../../utils/datetime-utils"
import {setCurrentFlightTime, setSubStore, deleteFlightTime} from "../../actions"
import {connect}  from "react-redux";

class FlightTimeItem extends React.Component {
    handleEdit = evt => {
        let { flightTime } = this.props;
        this.props.setCurrentFlightTime({
            startHour: flightTime.startTime.hours,
            startMinute: flightTime.startTime.minutes,
            endHour: flightTime.endTime.hours,
            endMinute: flightTime.endTime.minutes,
            timeSlotId: flightTime.timeSlotId
        })
        this.props.setModal(true);
    }
    handleDelete = evt => {
        this.props.deleteFlightTime(this.props.flightTime.timeSlotId);
    }
    render() {
        let { flightTime, index } = this.props;
        return (
            <Table.Row>
                <Table.Cell>{index}</Table.Cell>
                <Table.Cell>{getShortTimeStr(flightTime.startTime)}</Table.Cell>
                <Table.Cell>{getShortTimeStr(flightTime.endTime)}</Table.Cell>
                <Table.Cell>{subtractTime(flightTime.endTime, flightTime.startTime)}</Table.Cell>
                <Table.Cell>
                    <Button color="yellow" size="tiny" onClick={this.handleEdit}>Edit</Button>
                    <Button color="red" size="tiny" onClick={this.handleDelete}>Delete</Button>
                </Table.Cell>
            </Table.Row>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setCurrentFlightTime(flightTime) {
            dispatch(setCurrentFlightTime(flightTime))
        },
        deleteFlightTime(timeSlotId) {
            dispatch(deleteFlightTime(timeSlotId))
        },
        setModal(isOpen) {
            dispatch(setSubStore({
                openFlightTimeModal: isOpen
            }))
        }
    }
}

export default connect(null, mapDispatchToProps)(FlightTimeItem);