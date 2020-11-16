import DatePicker from "../util-components/date-picker";
import React from "react";

class FlightDate extends React.Component {
    handleChange = date => {
        this.props.setDate(date);
    }
    render() {
        let maxDate = new Date();
        maxDate.setFullYear(maxDate.getFullYear() + 1)
        return (
            <DatePicker
                maxDate={maxDate}
                placeholder="Choose flight date"
                onChange={this.handleChange}
                selected={this.props.selected}
            />
        )
    }
}

export default FlightDate;