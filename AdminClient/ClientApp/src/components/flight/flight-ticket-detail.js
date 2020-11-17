import React from "react"
import { Form } from "semantic-ui-react";
import {connect} from "react-redux";
import {setFlightTicketInfo} from "../../actions";

class TicketDetail extends React.Component {
    constructor(props) {
        super(props);
        let {ticketInfo, type} = props;
        this.state = {
            adultTicketPrice: ticketInfo[type-1].adultTicketPrice,
            adultTex: ticketInfo[type-1].adultTex,
            childTicketPrice: ticketInfo[type-1].childTicketPrice,
            childTex: ticketInfo[type-1].childTex,
            infantTicketPrice: ticketInfo[type-1].infantTicketPrice,
            infantTex: ticketInfo[type-1].infantTex,
            numberTicket: ticketInfo[type-1].numberTicket,
        }
    }
    handleChange = evt => {
        let target = evt.target;
        let name = target.name;
        let value = target.value.replace(/\D+/gi,'');
        this.setState({
            [name]: Number(value)
        }, () => {
            this.props.setTicketInfo(this.state, this.props.type - 1);
        })
    }
    render() {
        let { header } = this.props;
        let {adultTex, adultTicketPrice, childTicketPrice, childTex, 
            infantTex, infantTicketPrice, numberTicket} = this.state;
        return (
            <div className="col-10 mt-3">
                <div className="card">
                    <h5 className="card-header bg-info text-white">{header}</h5>
                    <div className="card-body">
                        <Form>
                            <Form.Group widths="equal">
                                <Form.Field>
                                    <label>Adult Ticket Price</label>
                                    <input type="text"
                                        onChange={this.handleChange}
                                        name="adultTicketPrice"
                                        placeholder="Adult ticket price"
                                        value={adultTicketPrice}
                                    />
                                </Form.Field>
                                <Form.Field>
                                    <label>Adult Tex</label>
                                    <input type="text"
                                        name="adultTex"
                                        placeholder="Adult tex"
                                        onChange={this.handleChange}
                                        value={adultTex} />
                                </Form.Field>
                            </Form.Group>
                            <Form.Group widths="equal">
                                <Form.Field>
                                    <label>Child Ticket Price</label>
                                    <input type="text"
                                        name="childTicketPrice"
                                        placeholder="Child ticket price"
                                        onChange={this.handleChange} 
                                        value={childTicketPrice}/>
                                </Form.Field>
                                <Form.Field>
                                    <label>Child Tex</label>
                                    <input type="text"
                                        name="childTex"
                                        placeholder="Child tex"
                                        onChange={this.handleChange} 
                                        value={childTex}/>
                                </Form.Field>
                            </Form.Group>
                            <Form.Group widths="equal">
                                <Form.Field>
                                    <label>Infant Ticket Price</label>
                                    <input type="text"
                                        name="infantTicketPrice"
                                        placeholder="Infant ticket price"
                                        onChange={this.handleChange} 
                                        value={infantTicketPrice}/>
                                </Form.Field>
                                <Form.Field>
                                    <label>Infant Tex</label>
                                    <input type="text"
                                        name="infantTex"
                                        placeholder="Infant tex"
                                        onChange={this.handleChange} 
                                        value={infantTex}/>
                                </Form.Field>
                            </Form.Group>
                            <Form.Group widths="16">
                                <Form.Field>
                                    <label>Number of tickets</label>
                                    <input type="text"
                                        name="numberTicket"
                                        placeholder="Number of tickets"
                                        onChange={this.handleChange}
                                        value={numberTicket}
                                    />
                                </Form.Field>
                            </Form.Group>
                        </Form>
                    </div>
                </div>
            </div>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setTicketInfo(ticketInfo, index) {
            dispatch(setFlightTicketInfo(ticketInfo, index))
        }
    }
}

const mapStateToProps = state => {
    return {
        ticketInfo: state.flightTicketInfo
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(TicketDetail)