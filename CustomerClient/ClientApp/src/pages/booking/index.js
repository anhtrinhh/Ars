import React from "react"
import "./style.scss";
import { Grid, Message } from "semantic-ui-react";
import BookingStep from "../../components/booking/booking-step";
import Cart from "../../components/booking/cart";
import Summary from "../../components/booking/summary";
import { Redirect, Switch } from "react-router-dom";
import RouteAction from "../../components/util-components/RouteAction";
import ModalBookingDetail from "../../components/booking/modal-booking-detail";

class Booking extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            isOpenCart: false,
            errorList: [],
            step: 1
        }
    }
    toggleCart = () => {
        this.setState({
            isOpenCart: !this.state.isOpenCart
        });
    }
    setError = (errArr) => {
        this.setState({
            errorList: errArr
        });
        window.scrollTo(0, 80);
    }
    clearError = () => {
        this.setState({
            errorList: []
        });
        window.scrollTo(0, 0)
    }
    setStep = stepNum => {
        this.setState({
            step: stepNum
        })
    }
    render() {
        let { isOpenCart, errorList, step } = this.state;
        let { location, match, routes } = this.props;
        return (location.pathname === match.url)
            ? <Redirect to={routes[0].path} />
            : routes.some(val => val.path === location.pathname)
                ? (
                    <div className="booking-wrapper">
                        <div className="container">
                            <Grid>
                                <BookingStep step={step} />
                            </Grid>
                            <div className={(isOpenCart ? "cart-active " : "") + "booking-main"}>
                                <div className="flight-selection">
                                    {errorList.length > 0
                                        ? <Message
                                            error
                                            header="Please verify your input"
                                            list={errorList}
                                        />
                                        : ''}
                                    <Switch>
                                        {routes.map((route, ix) => <RouteAction key={ix} {...route} />)}
                                    </Switch>
                                </div>
                                <Cart/>
                                <ModalBookingDetail />
                                <div className="overlay"></div>
                            </div>
                        </div>
                        <Summary toggleCart={this.toggleCart} {...this.props}
                            setError={this.setError}
                            clearError={this.clearError}
                            setStep={this.setStep} />
                    </div>
                )
                : <Redirect to="/notfound" />
    }
}

export default Booking;