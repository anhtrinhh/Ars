import React from "react"
import { Table, Icon } from "semantic-ui-react";
import { connect } from "react-redux";
import {Link} from "react-router-dom";

class SummaryTicket extends React.Component {
    render() {
        let { ticketInfo, showTicketClass } = this.props;
        let list = [];
        if (showTicketClass.showEconomy) {
            list.push(ticketInfo[0]);
        }
        if (showTicketClass.showPremium) {
            list.push(ticketInfo[1])
        }
        if (showTicketClass.showBusiness) {
            list.push(ticketInfo[2]);
        }
        return (
            <div className="card">
                <div className="card-header bg-info text-white d-flex justify-content-between align-items-center">
                    <h5 style={{marginBottom: 0}}>Ticket class detail</h5>
                    <Link to="/flight-management/add/2" style={{color: '#fff'}}>
                        <Icon name="edit" size="large"/>
                    </Link>
                </div>
                <div className="card-body">
                    <Table>
                        <Table.Header>
                            <Table.Row>
                                <Table.HeaderCell>No</Table.HeaderCell>
                                <Table.HeaderCell width="2">Ticket class</Table.HeaderCell>
                                <Table.HeaderCell>Adult ticket price</Table.HeaderCell>
                                <Table.HeaderCell>Child ticket price</Table.HeaderCell>
                                <Table.HeaderCell>Infant ticket price</Table.HeaderCell>
                                <Table.HeaderCell>Adult tex</Table.HeaderCell>
                                <Table.HeaderCell>Child tex</Table.HeaderCell>
                                <Table.HeaderCell>Infant tex</Table.HeaderCell>
                                <Table.HeaderCell width="2">Number of tickets</Table.HeaderCell>
                            </Table.Row>
                        </Table.Header>
                        <Table.Body>
                            {list.map((val, ix) => (
                                <Table.Row key={ix}>
                                    <Table.Cell>{ix + 1}</Table.Cell>
                                    <Table.Cell>
                                        {val.ticketClassId === 'ECO'
                                            ? "Ars Economy"
                                            : val.ticketClassId === 'PRE'
                                                ? "Ars Premium"
                                                : "Ars Business"}
                                    </Table.Cell>
                                    <Table.Cell>{val.adultTicketPrice} $</Table.Cell>
                                    <Table.Cell>{val.childTicketPrice} $</Table.Cell>
                                    <Table.Cell>{val.infantTicketPrice} $</Table.Cell>
                                    <Table.Cell>{val.adultTex} $</Table.Cell>
                                    <Table.Cell>{val.childTex} $</Table.Cell>
                                    <Table.Cell>{val.infantTex} $</Table.Cell>
                                    <Table.Cell>{val.numberTicket}</Table.Cell>
                                </Table.Row>
                            ))}
                        </Table.Body>
                    </Table>
                </div>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        ticketInfo: state.flightTicketInfo
    }
}

export default connect(mapStateToProps)(SummaryTicket);