import React from "react"
import { Segment, Icon } from "semantic-ui-react"

class TicketClassItem extends React.Component {
    render() {
        let { ticketClass } = this.props;
        let bgColor = ticketClass.ticketClassId === "ECO" ? "bg-success"
            : ticketClass.ticketClassId === "PRE" ? "bg-info" : "bg-primary";
        let textColor = ticketClass.ticketClassId === "ECO" ? "text-success"
            : ticketClass.ticketClassId === "PRE" ? "text-info" : "text-primary";
        let ticketClassName = ticketClass.ticketClassId === "ECO" ? "Ars Economy"
            : ticketClass.ticketClassId === "PRE" ? "Ars Premium" : "Ars Business";
        return (
            <Segment className="col-10 p-0">
                <div className="card">
                    <h5 className={`card-header ${bgColor} text-white`}>{ticketClassName}</h5>
                    <div className="card-body">
                        <div className="d-flex justify-content-center">
                            <Icon name="ticket" className={textColor} size="huge" />
                        </div>
                        <div className="row mt-2">
                            <div className="col-3">
                                <b>Number of tickets:</b>
                            </div>
                            <div className="col-3">
                                <p>{ticketClass.numberTicket}</p>
                            </div>
                        </div>
                        <div className="row mt-2">
                            <div className="col-3">
                                <b>Adult fare:</b>
                            </div>
                            <div className="col-3">
                                <p>{ticketClass.adultTicketPrice} $</p>
                            </div>
                            <div className="col-3">
                                <b>Child fare:</b>
                            </div>
                            <div className="col-3">
                                <p>{ticketClass.childTicketPrice} $</p>
                            </div>
                        </div>
                        <div className="row mt-2">
                            <div className="col-3">
                                <b>Infant fare:</b>
                            </div>
                            <div className="col-3">
                                <p>{ticketClass.infantTicketPrice} $</p>
                            </div>
                            <div className="col-3">
                                <b>Adult tex:</b>
                            </div>
                            <div className="col-3">
                                <p>{ticketClass.adultTex} $</p>
                            </div>
                        </div>
                        <div className="row mt-2">
                            <div className="col-3">
                                <b>Child Tex:</b>
                            </div>
                            <div className="col-3">
                                <p>{ticketClass.childTex} $</p>
                            </div>
                            <div className="col-3">
                                <b>Infant tex:</b>
                            </div>
                            <div className="col-3">
                                <p>{ticketClass.infantTex} $</p>
                            </div>
                        </div>
                    </div>
                </div>
            </Segment>
        )
    }
}

export default TicketClassItem;