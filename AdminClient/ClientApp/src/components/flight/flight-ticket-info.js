import React from "react"
import { connect } from "react-redux";
import { Button } from "semantic-ui-react";
import TicketDetail from "./flight-ticket-detail";
import TicketClass from "./flight-ticket-class";
import {setSubStore} from "../../actions"

class TicketInfo extends React.Component {
    constructor(props) {
        super(props);
        if (!props.flightid.trim()) {
            props.history.goBack();
        }
        this.state = {
            showBusiness: props.subStore.showBusiness,
            showEconomy: props.subStore.showEconomy,
            showPremium: props.subStore.showPremium
        }
    }
    checkValidate = () => {
        let success = true;
        let { ticketInfo } = this.props;
        let { showEconomy, showBusiness, showPremium } = this.state;
        if (showEconomy) {
            if (ticketInfo[0].adultTicketPrice === '' || ticketInfo[0].adultTex === ''
                || ticketInfo[0].childTicketPrice === '' || ticketInfo[0].childTex === ''
                || ticketInfo[0].infantTicketPrice === '' || ticketInfo[0].infantTex === ''
                || ticketInfo[0].numberTicket === '') {
                success = false;
            }
        }
        if (showPremium) {
            if (ticketInfo[1].adultTicketPrice === '' || ticketInfo[1].adultTex === ''
                || ticketInfo[1].childTicketPrice === '' || ticketInfo[1].childTex === ''
                || ticketInfo[1].infantTicketPrice === '' || ticketInfo[1].infantTex === ''
                || ticketInfo[1].numberTicket === '') {
                success = false;
            }
        }
        if (showBusiness) {
            if (ticketInfo[2].adultTicketPrice === '' || ticketInfo[2].adultTex === ''
                || ticketInfo[2].childTicketPrice === '' || ticketInfo[2].childTex === ''
                || ticketInfo[2].infantTicketPrice === '' || ticketInfo[2].infantTex === ''
                || ticketInfo[2].numberTicket === '') {
                success = false;
            }
        }
        return success;
    }
    handleBack = evt => {
        this.props.history.goBack();
    }
    handleShow = (isShow, type) => {
        if (type === 1) {
            this.setState({
                showEconomy: isShow
            }, () => {
                this.props.setSubStore({showEconomy: isShow})
            })
        } else if (type === 2) {
            this.setState({
                showPremium: isShow
            }, () => {
                this.props.setSubStore({showPremium: isShow})
            })
        } else {
            this.setState({
                showBusiness: isShow
            }, () => {
                this.props.setSubStore({showBusiness: isShow})
            })
        }
    }
    handleSubmit = evt => {
        let { showEconomy, showBusiness, showPremium } = this.state;
        this.props.history.push("3", {
            from: this.props.location,
            showEconomy, showBusiness, 
            showPremium
        })
    }
    render() {
        let isDisable = !this.checkValidate();
        let { showEconomy, showBusiness, showPremium } = this.state;
        return (
            <React.Fragment>
                <h4>Ticket class information</h4>
                <div className="row">
                    <div className="col-12 d-flex">
                        <TicketClass type={1} isShow={showEconomy} handleShow={this.handleShow} />
                        <TicketClass type={2} isShow={showPremium} handleShow={this.handleShow} />
                        <TicketClass type={3} isShow={showBusiness} handleShow={this.handleShow} />
                    </div>
                </div>
                <div className="row">
                    {showEconomy
                        ? <TicketDetail header="Economy ticket class"
                            type={1}
                        />
                        : ''}
                    {showPremium
                        ? <TicketDetail header="Premium ticket class"
                            type={2}
                        />
                        : ''}
                    {showBusiness
                        ? <TicketDetail header="Business ticket class"
                            type={3}
                        />
                        : ''}
                    <div className="col-10 mt-3 d-flex justify-content-center">
                        <Button color="black" size="large" onClick={this.handleBack}>Back</Button>
                        <Button color="green"
                            size="large"
                            className="ml-5"
                            disabled={isDisable}
                            onClick={this.handleSubmit}
                        >Next</Button>
                    </div>
                </div>
            </React.Fragment>
        )
    }
}

const mapStateToProps = state => {
    return {
        flightid: state.flightBasicInfo.flightid,
        ticketInfo: state.flightTicketInfo,
        subStore: state.subStore
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setSubStore(state) {
            dispatch(setSubStore(state))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(TicketInfo);