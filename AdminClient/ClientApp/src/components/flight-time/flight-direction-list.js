import React from "react";
import FlightDirectionItem from "../flight-direction/flight-direction-item"
import "../flight-direction/style.scss";

class FlightDirectionList extends React.Component {
    createFlightItems = (flightDirection) => {
        let flightDirectionItems = [];
        for(let fd in flightDirection) {
            let items = [];
            for(let plan in flightDirection[fd].flightplan) {
                let link = `/flight-time-management/${fd}/${plan}`
                items.push(
                    <FlightDirectionItem key={plan} link={link} from={fd} to={plan}/>
                )
            }
            flightDirectionItems.push(
                <React.Fragment key={fd}>
                    <h4>Flights from {flightDirection[fd].city}:</h4>
                    <div className="row flight-direction-list mb-3">
                        {items}
                    </div>
                </React.Fragment>
            )
        }
        return flightDirectionItems;
    }
    render() {
        let {flightDirection} = this.props;
        let flightDirectionItems = this.createFlightItems(flightDirection);
        return (
            <div className="flight-direction-list-wrapper">
                {flightDirectionItems}
            </div>
        )
    }
}


export default FlightDirectionList;