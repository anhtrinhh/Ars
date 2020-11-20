import React from "react"
import "./style.scss";
import SelectTime from "./select-time"


class SelectFlightTime extends React.Component {
    constructor(props) {
        super(props);
        let  {time} = props;
        this.state = {
            startHour: time.startHour,
            startMinute: time.startMinute,
            endHour: time.endHour,
            endMinute: time.endMinute
        }
    }
    setTime = (hour, minute, type) => {
        if(type === 1) {
            this.setState({
                startHour: hour,
                startMinute: minute
            }, this.changeTime)
        } else {
            this.setState({
                endHour: hour,
                endMinute: minute
            }, this.changeTime)
        }
    }
    changeTime = () => {
        let {startHour, startMinute, endHour, endMinute} = this.state;
        if(this.props.onChangeTime) {
            this.props.onChangeTime(startHour, startMinute, endHour, endMinute);
        }
    }
    render() {
        let {startHour, startMinute, endHour, endMinute} = this.state;
        return (
            <div className="select-time-wrapper">
                <SelectTime label="Start time" setTime={this.setTime} type={1} hour={startHour} minute={startMinute}/>
                <SelectTime label="End time" setTime={this.setTime} type={2} hour={endHour} minute={endMinute}/>
            </div>
        )
    }
}

export default SelectFlightTime;