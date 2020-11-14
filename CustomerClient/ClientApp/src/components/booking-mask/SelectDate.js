import FromDateField from "./FromDateField";
import ToDateField from "./ToDateField";
import React from "react";


class SelectDate extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            fromFocus: false,
            toFocus: false,
            from: null,
            to: null,
            fromMin: new Date(),
            fromMax: null,
            toMin: new Date()
        }
    }
    setChooseDate = (date, field) => {
        if(field.toUpperCase() === "FROM") {
            this.setState({
                from: date,
                toMin: date
            });
        } else {
            this.setState({
                to: date,
                fromMax: date
            });
        }
        this.props.getDate(date, field);
    }
    setFocus = (field) => {
        if (field.toUpperCase() === "FROM") {
            this.setState({
                toFocus: this.state.to ? false : true,
                fromFocus: false
            });
        } else {
            this.setState({
                toFocus: false,
                fromFocus: this.state.from ? false : true
            });
        }
    }
    render() {
        let { fromFocus, toFocus, from, to, toMin, fromMin, fromMax } = this.state;
        let {isRoundTrip} = this.props;
        return (
            <div className="tab-search__form-row">
                <FromDateField focus={fromFocus}
                    setFieldFocus={this.setFocus}
                    setChooseDate={this.setChooseDate}
                    date={from}
                    minDate={fromMin}
                    maxDate={fromMax}
                />
                {
                    isRoundTrip 
                    ? (<ToDateField focus={toFocus}
                        setFieldFocus={this.setFocus}
                        minDate={toMin}
                        date={to}
                        setChooseDate={this.setChooseDate}
                    />)
                    : ''
                }
            </div>
        )
    }
}

export default SelectDate;