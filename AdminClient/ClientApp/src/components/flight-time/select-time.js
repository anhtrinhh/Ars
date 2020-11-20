import React from "react"
import { Dropdown } from "semantic-ui-react"


let hourOptions = [];
let minuteOptions = [];
for (let i = 0; i < 24; i++) {
    if (i < 10) {
        hourOptions.push({
            key: i,
            text: "0" + i,
            value: i
        })
    } else {
        hourOptions.push({
            key: i,
            text: i + "",
            value: i 
        })
    }
}
for (let i = 0; i < 60; i++) {
    if (i < 10) {
        minuteOptions.push({
            key: i,
            text: "0" + i,
            value: i
        })
    } else {
        minuteOptions.push({
            key: i,
            text: i + "",
            value: i 
        })
    }
}
class SelectTime extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            hour: props.hour,
            minute: props.minute
        }
    }
    handleChangeMinute = (evt, data) => {
        this.setState({
            minute: data.value
        }, this.setTime)
    }

    handleChangeHour = (evt, data) => {
        this.setState({
            hour: data.value
        }, this.setTime)
    }
    setTime = () => {
        this.props.setTime(this.state.hour, this.state.minute, this.props.type)
    }
    render() {
        let { label } = this.props;
        let {hour, minute} = this.state;
        return (
            <React.Fragment>
                <label>{label}</label>
                <div className="select-time">
                    <div className="times">
                        <div className="time">
                            <Dropdown selection
                                options={hourOptions}
                                search
                                onChange={this.handleChangeHour}
                                value={hour}
                            />
                            <span>hh</span>
                        </div>
                    </div>
                    <div className="times">
                        <div className="time">
                            <Dropdown selection
                                options={minuteOptions}
                                search
                                onChange={this.handleChangeMinute}
                                value={minute}
                            />
                            <span>mm</span>
                        </div>
                    </div>
                </div>
            </React.Fragment>
        )
    }
}

export default SelectTime;