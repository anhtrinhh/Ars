import React from "react"
import { Button, Modal, Message } from "semantic-ui-react";
import { connect } from "react-redux";
import { setSubStore, insertFlightTime, updateFlightTime } from "../../actions";
import SelectFlightTime from "./select-flight-time"

class FlightTimeModel extends React.Component {
    constructor(props) {
        super(props);
        let {currentFlightTime} = props;
        this.state = {
            startHour: currentFlightTime ? currentFlightTime.startHour : 0,
            startMinute: currentFlightTime ? currentFlightTime.startMinute : 0,
            endHour: currentFlightTime ? currentFlightTime.endHour : 0,
            endMinute: currentFlightTime ? currentFlightTime.endMinute : 0,
            timeSlotId: currentFlightTime ? currentFlightTime.timeSlotId : null,
            showError: false
        }
    }
    UNSAFE_componentWillReceiveProps(nextProps) {
        let {currentFlightTime} = nextProps;
        this.setState({
            startHour: currentFlightTime ? currentFlightTime.startHour : 0,
            startMinute: currentFlightTime ? currentFlightTime.startMinute : 0,
            endHour: currentFlightTime ? currentFlightTime.endHour : 0,
            endMinute: currentFlightTime ? currentFlightTime.endMinute : 0,
            timeSlotId: currentFlightTime ? currentFlightTime.timeSlotId : null,
        })
    }
    handleClose = evt => {
        this.props.setModal(false)
    }
    handleChangeTime = (startHour, startMinute, endHour, endMinute) => {
        this.setState({
            startHour,
            startMinute,
            endHour,
            endMinute,
            showError: false
        })
    }
    handleSave = evt => {
        let { startHour, startMinute, endHour, endMinute } = this.state;
        if (startHour > endHour || (startHour === endHour && startMinute >= endMinute)) {
            this.setState({
                showError: true
            })
        } else {
            let { currentFlightTime } = this.props;
            let {from, to} = this.props.match.params;
            if (currentFlightTime) {
                this.props.updateFlightTime(this.state, from, to);
            } else {
                this.props.insertFlightTime(this.state, from, to);
            }
        }
    }
    render() {
        let { openFlightTimeModal, currentFlightTime } = this.props;
        let { showError } = this.state;
        return (
            <Modal open={openFlightTimeModal} onClose={this.handleClose} size="mini">
                <Modal.Header>{
                    currentFlightTime ? 'Edit flight time' : 'Add flight time'
                }</Modal.Header>
                <Modal.Content>
                    {showError && <Message error header="Invalid flight time" />}
                    <SelectFlightTime onChangeTime={this.handleChangeTime} time={this.state}/>
                </Modal.Content>
                <Modal.Actions>
                    <Button positive onClick={this.handleSave}>Save</Button>
                    <Button onClick={this.handleClose}>Cancel</Button>
                </Modal.Actions>
            </Modal>
        )
    }
}

const mapStateToProps = state => {
    return {
        openFlightTimeModal: state.subStore.openFlightTimeModal,
        currentFlightTime: state.currentFlightTime
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setModal(isOpen) {
            dispatch(setSubStore({
                openFlightTimeModal: isOpen
            }))
        },
        insertFlightTime(flightTime, startPointId, endPointId) {
            dispatch(insertFlightTime(flightTime, startPointId, endPointId))
        },
        updateFlightTime(flightTime,startPointId, endPointId) {
            dispatch(updateFlightTime(flightTime, startPointId, endPointId))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(FlightTimeModel);