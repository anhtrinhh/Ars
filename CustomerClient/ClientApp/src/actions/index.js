import * as ActionType from "../constants/action-type";
import ApiCaller from "../utils/apicaller";

export function SetLoader(loaderState) {
    return {
        type: ActionType.SET_LOADER,
        loaderState
    }
}

export function SetCurrentCustomer(customer) {
    return {
        type: ActionType.SET_CURRENT_CUSTOMER,
        customer
    }
}

export function ClearCurrentCustomer() {
    return {
        type: ActionType.CLEAR_CURRENT_CUSTOMER
    }
}

export function GetCustomer(token) {
    return dispatch => {
        return ApiCaller("customeraccount/getcustomer", "get", null, {
            'Authorization': 'Bearer ' + token
        }).then(res => {
            dispatch(SetCurrentCustomer(res.data))
            if (res.data) {
                dispatch(SetSignin(true))
            } else {
                dispatch(SetSignin(false))
            }
        }).catch(err => {
            console.log(err);
            dispatch(SetSignin(false))
        })
    }
}

export function UploadCustomerAvatar(formData) {
    return dispatch => {
        let token = sessionStorage.getItem("token") || localStorage.getItem("token");
        return ApiCaller("customeraccount/updatecustomeravatar", "PUT", formData, {
            'Authorization': 'Bearer ' + token
        })
            .then(res => {
                dispatch(SetCurrentCustomer({
                    customerAvatar: res.data
                }))
            })
            .catch(err => {
                console.log(err)
            })
    }
}

export function UpdateCustomerPassword(customerPassword) {
    return dispatch => {
        let token = sessionStorage.getItem("token") || localStorage.getItem("token");
        return ApiCaller("customeraccount/updatecustomerpassword", "PUT", customerPassword, {
            'Authorization': 'Bearer ' + token
        }).then(res => {
            if (res.data) {
                dispatch(SetModal({
                    modalInform: {
                        state: true,
                        title: 'Update successfully',
                        inform: 'You have successfully updated your password',
                        type: 1
                    }
                }))
            } else {
                dispatch(SetModal({
                    modalInform: {
                        state: true,
                        title: 'Update failed',
                        inform: 'Update failed, please try again',
                        type: 0
                    }
                }))
            }
        }).catch(err => {
            console.log(err);
            dispatch(SetModal({
                modalInform: {
                    state: true,
                    title: 'Update failed',
                    inform: 'Update failed, please try again',
                    type: 0
                }
            }))
        })
    }
}

export function UpdateCustomer(customer, type) {
    return dispatch => {
        let token = sessionStorage.getItem("token") || localStorage.getItem("token");
        let endpoint = type === 1 ? "updatecustomerbasicinfo" : "updatecustomercontactinfo";
        return ApiCaller("customeraccount/" + endpoint, "PUT", customer, {
            'Authorization': 'Bearer ' + token
        }).then(res => {
            if (res.data) {
                if (type === 1) {
                    dispatch(SetCurrentCustomer({
                        customerFirstName: res.data.customerFirstName,
                        customerLastName: res.data.customerLastName,
                        customerGender: res.data.customerGender,
                        customerBirthday: res.data.customerBirthday
                    }));
                } else {
                    dispatch(SetCurrentCustomer({
                        customerPhoneNumber: res.data.customerPhoneNumber,
                        customerIdentification: res.data.customerIdentification,
                        customerAddress: res.data.customerAddress
                    }));
                }
                dispatch(SetModal({
                    modalInform: {
                        state: true,
                        title: 'Update successfully',
                        inform: 'You have successfully updated your information',
                        type: 1
                    }
                }))
            } else {
                dispatch(SetModal({
                    modalInform: {
                        state: true,
                        title: 'Update failed',
                        inform: 'Update failed, please try again',
                        type: 0
                    }
                }))
            }
        }).catch(err => {
            dispatch(SetModal({
                modalInform: {
                    state: true,
                    title: 'Update failed',
                    inform: 'Update failed, please try again',
                    type: 0
                }
            }))
            console.log(err)
        })
    }
}

export function SetFlightDirection(flightDirection) {
    return {
        type: ActionType.SET_FLIGHT_DIRECTION,
        flightDirection
    }
}

export function GetFlightDirection() {
    return dispatch => {
        return ApiCaller("flightdirection").then(res => {
            dispatch(SetFlightDirection(res.data))
        }).catch(err => {
            console.log(err)
        })
    }
}

export function SetNumberGuest(numberGuest) {
    return {
        type: ActionType.SET_NUMBER_GUEST,
        numberGuest
    }
}

export function ClearBookingInfo() {
    return {
        type: ActionType.CLEAR_BOOKING_INFO
    }
}

export function SetInitFlight(amount) {
    return {
        type: ActionType.SET_INIT_FLIGHT,
        amount
    }
}

export function SetTicket(flight, ticketClassDetail, index) {
    return {
        type: ActionType.SET_TICKET,
        ticketClassDetail,
        index,
        flight
    }
}

export function SetGuestInfo(guestInfo, indexTicket) {
    return {
        type: ActionType.SET_GUEST_INFO,
        guestInfo,
        indexTicket
    }
}

export function SetCart(startPointId, endPointId) {
    return {
        type: ActionType.SET_CART,
        startPointId,
        endPointId
    }
}

export function SetSignin(isSignin) {
    return {
        type: ActionType.SET_SIGNIN,
        isSignin
    }
}

export function SetOpenModalBookingDetail(isOpenModal) {
    return {
        type: ActionType.SET_OPEN_BOOKING_DETAIL,
        isOpenModal
    }
}

export function SetModal(modalState) {
    return {
        type: ActionType.SET_MODAL,
        modalState
    }
}

export function SetFlightIndex(flightIndex) {
    return {
        type: ActionType.SET_FLIGHT_INDEX,
        flightIndex
    }
}

export function SetBankCard(bankCard) {
    return {
        type: ActionType.SET_BANK_CARD,
        bankCard
    }
}

export function SetErrorBankCard(err) {
    return {
        type: ActionType.SET_ERROR_BANK_CARD,
        err
    }
}

export async function PostTicket(flight, bookingId) {
    let token = sessionStorage.getItem("token") || localStorage.getItem("token");
    let success = true;
    if (token) {
        for (let i = 0; i < flight.tickets.length; i++) {
            let ticket = getTicket(flight, i, bookingId);
            try {
                let res = await ApiCaller("ticket", "post", ticket, {
                    'Authorization': 'Bearer ' + token
                });
                success = res.data;
            } catch (err) {
                success = false;
            }
            if (!success) {
                break;
            }
        }
    } else {
        success = false;
    }
    return success;
}

export function PostBooking(bookingInfo) {
    return async dispatch => {
        let token = sessionStorage.getItem("token") || localStorage.getItem("token");
        let success = true;
        if (token) {
            dispatch(SetLoader(true));
            for (let i = 0; i < bookingInfo.flights.length; i++) {
                let booking = getBooking(bookingInfo, i);
                let res = await ApiCaller("booking", "post", booking, {
                    'Authorization': 'Bearer ' + token
                });
                if (res.data) {
                    let isInsertedTicket = await PostTicket(bookingInfo.flights[i], res.data);
                    if (!isInsertedTicket) {
                        success = false;
                        break;
                    }
                } else {
                    success = false;
                    break;
                }
            }
            dispatch(SetLoader(false))
        } else {
            success = false;
        }
        if (success) {
            dispatch(SetModal({
                isOpenModalBookingSuccess: true
            }));
        } else {
            dispatch(SetModal({
                isOpenModalBookingFail: true
            }));
        }
    }
}

function getBooking(bookingInfo, index) {
    let booking = {};
    booking.numberAdults = bookingInfo.numberAdults;
    booking.numberChildren = bookingInfo.numberChildren;
    booking.numberInfants = bookingInfo.numberInfants;
    booking.totalTex = bookingInfo.flights[index].totalTex;
    booking.totalTicketPrice = bookingInfo.flights[index].totalTicketPrice;
    booking.flightId = bookingInfo.flights[index].flightId;
    return booking;
}

function getTicket(flight, ix, bookingId) {
    let ticket = {};
    ticket.bookingId = bookingId;
    ticket.ticketClassDetailId = flight.ticketClassDetailId;
    ticket.ticketClass = flight.ticketClass;
    ticket.ticketPrice = flight.tickets[ix].ticketPrice;
    ticket.guestFirstName = flight.tickets[ix].guestFirstName;
    ticket.guestLastName = flight.tickets[ix].guestLastName;
    ticket.guestGender = flight.tickets[ix].guestGender;
    ticket.guestBirthday = flight.tickets[ix].guestBirthday;
    return ticket;
}

export function SetFlight(flights) {
    return {
        type: ActionType.SET_FLIGHT,
        flights
    }
}

export function SetCurrentFlight(pageNumber) {
    return {
        type: ActionType.SET_CURRENT_FLIGHT,
        pageNumber
    }
}

export function GetFlights() {
    return dispatch => {
        let token = sessionStorage.getItem("token") || localStorage.getItem("token");
        return ApiCaller("booking", "get", null, {
            'Authorization': 'Bearer ' + token
        }).then(res => {
            if(res.data.length > 0) {
                dispatch(SetFlight(res.data))
            }
        }).catch(err => {
            console.log(err)
        })
    }
}

export function SetBookingDetailModal(isOpenModal) {
    return {
        type: ActionType.SET_BOOKING_DETAIL_MODAL,
        isOpenModal
    }
}

export function SetCurrFlight(index) {
    return {
        type: ActionType.SET_CURR_FLIGHT,
        index
    }
}