import React from "react"
import { Button, Icon } from "semantic-ui-react";
import { connect } from "react-redux";
import { SetErrorBankCard, PostBooking } from "../../actions";

class Summary extends React.Component {
    state = {
        confirmBtn: false
    }
    handleToggleCart = evt => {
        this.props.toggleCart();
    }
    handleBack = evt => {
        this.props.history.goBack();
        this.props.clearError();
    }
    static getDerivedStateFromProps(props, state) {
        if (props.location.pathname === "/booking/flights") {
            props.setStep(1);
        } else if (props.location.pathname === "/booking/guest-info") {
            props.setStep(2);
        } else if (props.location.pathname === "/booking/payment") {
            props.setStep(3);
            return {
                confirmBtn: true
            }
        }
        return {
            confirmBtn: false
        }
    }
    handleNext = evt => {
        if (this.props.location.pathname === "/booking/flights") {
            let err = checkValidate1(this.props.bookingInfo);
            if (err.length > 0) {
                this.props.setError(err);
            } else {
                if (this.props.subStore.isSignin) {
                    this.props.history.push("/booking/guest-info", { from: this.props.location });
                } else {
                    this.props.history.push("/signin", { from: "/booking/guest-info" });
                }
                this.props.clearError();
            }
        } else if (this.props.location.pathname === "/booking/guest-info") {
            let err = checkValidate2(this.props.bookingInfo);
            if (err.length > 0) {
                this.props.setError(err)
            } else {
                this.props.history.push("/booking/payment", { from: this.props.location });
                this.props.clearError();
            }
        } else if (this.props.location.pathname === "/booking/payment") {
            let err = checkValidate3(this.props.bankCard);
            if (err.errCardNumber || err.errExpireMonth || err.errExpireYear
                || err.errCardHolder || err.errSafelyCode) {
                this.props.setErrorBankCard(err);
                window.scrollTo(0, document.body.offsetHeight);
            } else {
                this.props.postBooking(this.props.bookingInfo)
            }
        }
    }
    render() {
        let { confirmBtn } = this.state;
        return (
            <div className="summary">
                <div className="summary-wrapper">
                    <div className="container">
                        <Button size="large" color="grey" onClick={this.handleBack}>Back</Button>
                        <div className="cart" onClick={this.handleToggleCart}>
                            <Icon name="cart" />
                            <span>Cart</span>
                        </div>
                        <Button size="large" color="green" onClick={this.handleNext}>
                            {confirmBtn ? "Confirm" : "Next"}
                        </Button>
                    </div>
                </div>
            </div>
        )
    }
}

function checkValidate1(bookingInfo) {
    let err = []
    if (bookingInfo.numberAdults > 0 && bookingInfo.numberChildren >= 0 && bookingInfo.numberInfants >= 0) {
        if (bookingInfo.flights.length > 0 && bookingInfo.flights.length < 3) {
            bookingInfo.flights.forEach((val, ix) => {
                if (!val.flightId) {
                    if (ix === 0) {
                        err.push("Please choose your outbound flight.");
                    } else {
                        err.push("Please choose your inbound flight.");
                    }
                }
            });
        }
    }
    return err;
}

function checkValidate2(bookingInfo) {
    let err = [];
    bookingInfo.flights[0].tickets.forEach((val, ix) => {
        if (!val.guestFirstName) {
            err.push("Please enter the first name of the customer " + (ix + 1))
        }
        if (!val.guestLastName) {
            err.push("Please enter the last name of the customer " + (ix + 1))
        }
        if (!val.guestBirthday) {
            err.push("Please choose the birthday of the customer " + (ix + 1))
        }
    });
    return err;
}

function checkValidate3(bankCard) {
    let err = {
        errCardNumber: null,
        errExpireMonth: null,
        errExpireYear: null,
        errCardHolder: null,
        errSafelyCode: null
    }
    let date = new Date();
    if (!bankCard.cardNumber.replace(/\W+/g, '')) {
        err.errCardNumber = 'Please enter your card number';
    } else if (!/^\d{16}$/.test(bankCard.cardNumber.replace(/\s+/g, ''))) {
        err.errCardNumber = 'Invalid card number';
    }
    if (!bankCard.expireMonth) {
        err.errExpireMonth = 'Please choose'
    } else if (bankCard.expireMonth < date.getMonth() + 1 && bankCard.expireYear === date.getFullYear()) {
        err.errExpireMonth = 'Invalid expire month';
    }
    if (!bankCard.expireYear) {
        err.errExpireYear = 'Please choose'
    }
    if (!bankCard.cardHolder.trim()) {
        err.errCardHolder = 'Please enter your cardholder name';
    } else if (bankCard.cardHolder.trim().length < 3) {
        err.errCardHolder = 'Invalid cardholder name';
    }
    if (!bankCard.safelyCode.trim()) {
        err.errSafelyCode = 'Please enter your safety code';
    } else if (!/^\d{3}$/.test(bankCard.safelyCode.trim())) {
        err.errSafelyCode = 'Invalid safety code';
    }
    return err;
}

const mapStateToProps = state => {
    return {
        bookingInfo: state.BookingInfo,
        subStore: state.SubStore,
        bankCard: state.BankCard
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setErrorBankCard(err) {
            dispatch(SetErrorBankCard(err))
        },
        postBooking(bookingInfo) {
            dispatch(PostBooking(bookingInfo))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(Summary);