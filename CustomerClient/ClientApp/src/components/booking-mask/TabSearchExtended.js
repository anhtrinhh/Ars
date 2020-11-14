import SelectDate from "./SelectDate";
import SelectGuest from "./SelectGuest";
import React from "react";


class TabSearchExtended extends React.Component {
    state = {
        isRoundTrip: true
    }
    getDate = (date, field) => {
        this.props.setDate(date, field);
    }
    handleChooseFlightType = evt => {
        let id = evt.target.id;
        if(id === "btnroundtrip") {
            document.getElementById("btnroundtrip").classList.add("active");
            document.getElementById("btnonetrip").classList.remove("active");
            this.props.setTrip(true);
            this.setState({
                isRoundTrip: true
            })
        } else {
            document.getElementById("btnroundtrip").classList.remove("active");
            document.getElementById("btnonetrip").classList.add("active");
            this.props.setTrip(false);
            this.setState({
                isRoundTrip: false
            })
        }
    }
    render() {
        let {extend} = this.props;
        return (
            <div className={(extend ? "extended " : "") + "tab-search__extended"}>
                <div className="tab-search__row">
                    <div className="tab-search__form-field--1">
                        <div className="flight-type">
                            <button className="active" id="btnroundtrip" onClick={this.handleChooseFlightType}>Round Trip</button>
                            <button id="btnonetrip" onClick={this.handleChooseFlightType}>One Trip</button>
                        </div>
                    </div>
                </div>
                <SelectDate isRoundTrip={this.state.isRoundTrip} getDate={this.getDate} />
                <SelectGuest />
            </div>
        )
    }
}

export default TabSearchExtended;