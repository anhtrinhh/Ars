import React from "react"
import { Segment } from "semantic-ui-react"
import {connect} from "react-redux";
import TicketClassItem from "./ticket-class-item";

class TicketInfo extends React.Component {
    render() {
        let {ticketClassDetail} = this.props.currentFlight
        return (
            <Segment className="row col-10">
                <div className="col-12">
                    <h4>Ticket class information</h4>
                </div>
                <div className="col-12">
                    <div className="row">
                        {ticketClassDetail.map((val, ix) => (
                            <TicketClassItem key={ix} ticketClass={val}/>
                        ))}
                    </div>
                </div>
            </Segment>
        )
    }
}

const mapStateToProps = state => {
    return {
        currentFlight: state.currentFlight
    }
}

export default connect(mapStateToProps)(TicketInfo);