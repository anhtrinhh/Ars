import * as actionType from "../constants/action-type";
import * as env from "../constants/env";
import callApi from "../utils/api-util";
import { getShortTimeStr } from "../utils/datetime-utils"

export function setSubStore(data) {
    return {
        type: actionType.SET_SUB_STORE,
        data
    }
}

export function setCurrentAccount(account) {
    return {
        type: actionType.SET_CURRENT_ACCOUNT,
        account
    }
}

 export function setCurrentEmployees(employees) {
    return {
        type: actionType.SET_CURRENT_EMPLOYEES,
        employees
    }
}

export function clearCurrentAccount() {
    return {
        type: actionType.CLEAR_CURRENT_ACCOUNT
    }
}

export function signin(resolve, reject, signInfo) {
    return dispatch => {
        dispatch(setSubStore({ isShowLoader: true }));
        return callApi(env.SIGN_IN_ENDPOINT, "post", signInfo)
            .then(res => {
                if (res.data) {
                    let { token } = res.data;
                    callApi(env.GET_ADMIN_ENDPOINT, "get", null, {
                        'Authorization': 'Bearer ' + token
                    }).then(rp => {
                        if (rp.data) {
                            dispatch(setCurrentAccount({
                                jwtToken: token,
                                ...rp.data
                            }));
                            dispatch(setSubStore({ isShowLoader: false }));
                            resolve();
                        } else {
                            reject();
                            dispatch(setSubStore({ isShowLoader: false }));
                        }
                    }).catch(err => {
                        reject();
                        dispatch(setSubStore({ isShowLoader: false }));
                        console.log(err)
                    })
                } else {
                    reject();
                    dispatch(setSubStore({ isShowLoader: false }));
                }
            }).catch(err => {
                reject();
                dispatch(setSubStore({ isShowLoader: false }));
                console.log(err);
            })
    }
}

export function setFlightDirection(flightDirection) {
    return {
        type: actionType.SET_FLIGHT_DIRECTION,
        flightDirection
    }
}

export function getFlightDirection() {
    return dispatch => {
        return callApi(env.GET_FLIGHT_DIRECTION_ENDPOINT).then(res => {
            dispatch(setFlightDirection(res.data))
        }).catch(err => {
            console.log(err)
        })
    }
}

export function setCurrentFlights(flights) {
    return {
        type: actionType.SET_CURRENT_FLIGHTS,
        flights
    }
}

export function searchFlight(from, to, flightDate) {
    return dispatch => {
        let endpoint = `${env.SEARCH_FLIGHT_ENDPOINT}?from=${from}&to=${to}&date1=${flightDate}`;
        dispatch(setSubStore({ isShowLoader: true }));
        return callApi(endpoint).then(res => {
            dispatch(setCurrentFlights(res.data))
            dispatch(setSubStore({ isShowLoader: false }));
        }).catch(err => {
            console.log(err);
            dispatch(setSubStore({ isShowLoader: false }));
        })
    }
}

export function setRestTimeSlot(timeSlots) {
    return {
        type: actionType.SET_REST_TIME_SLOT,
        timeSlots
    }
}

export function setCurrentFlightTimes(flightTimes) {
    return {
        type: actionType.SET_CURRENT_FLIGHT_TIMES,
        flightTimes
    }
}

export function getTimeSlot1(fromid, toid, flightdate, token) {
    return dispatch => {
        let endpoint = `${env.GET_REST_TIMESLOT_ENDPOINT}/${fromid}/${toid}/${flightdate}`;
        dispatch(setSubStore({ isShowLoader: true }))
        return callApi(endpoint, "get", null, {
            'Authorization': 'Bearer ' + token
        }).then(res => {
            dispatch(setRestTimeSlot(res.data))
            dispatch(setSubStore({ isShowLoader: false }))
        }).catch(err => {
            console.log(err)
            dispatch(setSubStore({ isShowLoader: false }))
        })
    }
}

export function getTimeSlot2(fromid, toid) {
    return dispatch => {
        let endPoint = `${env.FLIGHT_TIME_ENDPOINT}/${fromid}/${toid}`;
        dispatch(setSubStore({ isShowLoader: true }))
        return callApi(endPoint).then(res => {
            dispatch(setCurrentFlightTimes(res.data))
            dispatch(setSubStore({ isShowLoader: false }))
        }).catch(err => {
            console.log(err);
            dispatch(setSubStore({ isShowLoader: false }))
        })
    }
}

export function addFlighTime(flightTime) {
    return {
        type: actionType.ADD_FLIGHT_TIME,
        flightTime
    }
}

function createFlightTime(flightTime) {
    let flightT = { ...flightTime };
    if (flightT.startHour < 10) {
        flightT.startHour = "0" + flightT.startHour;
    }
    if (flightT.startMinute < 10) {
        flightT.startMinute = "0" + flightT.startMinute;
    }
    if (flightT.endHour < 10) {
        flightT.endHour = "0" + flightT.endHour;
    }
    if (flightT.endMinute < 10) {
        flightT.endMinute = "0" + flightT.endMinute;
    }
    return {
        startTime: `${flightT.startHour}:${flightT.startMinute}`,
        endTime: `${flightT.endHour}:${flightT.endMinute}`
    }
}

export function insertFlightTime(flightTime, startPointId, endPointId) {
    return dispatch => {
        let formData = new FormData();
        let flightT = createFlightTime(flightTime);
        formData.append("startTime", flightT.startTime);
        formData.append("endTime", flightT.endTime);
        formData.append("startPointId", startPointId);
        formData.append("endPointId", endPointId);
        dispatch(setSubStore({ isShowLoader: true }))
        return callApi(env.FLIGHT_TIME_ENDPOINT, "post", formData).then(res => {
            dispatch(setSubStore({ openFlightTimeModal: false }))
            if (res.data) {
                window.location.reload();
            } else {
                dispatch(setInformModal({
                    icon: "remove circle",
                    header: "Fail",
                    conten: "Add flight time failed",
                    type: 2,
                    open: true
                }))
            }
            dispatch(setSubStore({ isShowLoader: false }))
        }).catch(err => {
            dispatch(setSubStore({ openFlightTimeModal: false }))
            dispatch(setSubStore({ isShowLoader: false }))
            dispatch(setInformModal({
                icon: "remove circle",
                header: "Fail",
                conten: "Add flight time failed",
                type: 2,
                open: true
            }))
            console.log(err);
        })
    }
}

export function deleteFlightTime(timeSlotId) {
    return dispatch => {
        let confirm = window.confirm("Do you want to delete this flight time?");
        if (confirm) {
            dispatch(setSubStore({ isShowLoader: true }))
            return callApi(env.FLIGHT_TIME_ENDPOINT + "/" + timeSlotId, "delete").then(res => {
                if (res.data) {
                    window.location.reload();
                } else {
                    dispatch(setInformModal({
                        icon: "remove circle",
                        header: "Fail",
                        conten: "Delete flight time failed",
                        type: 2,
                        open: true
                    }))
                }
                dispatch(setSubStore({ isShowLoader: false }))
            }).catch(err => {
                dispatch(setInformModal({
                    icon: "remove circle",
                    header: "Fail",
                    conten: "Delete flight time failed",
                    type: 2,
                    open: true
                }))
                dispatch(setSubStore({ isShowLoader: false }))
                console.log(err);
            })
        }
    }
}

export function updateFlightTime(flightTime, startPointId, endPointId) {
    return dispatch => {
        let formData = new FormData();
        let flightT = createFlightTime(flightTime);
        formData.append("startTime", flightT.startTime);
        formData.append("endTime", flightT.endTime);
        formData.append("startPointId", startPointId);
        formData.append("endPointId", endPointId);
        formData.append("timeSlotId", flightTime.timeSlotId)
        dispatch(setSubStore({ isShowLoader: true }))
        return callApi(env.FLIGHT_TIME_ENDPOINT, "put", formData).then(res => {
            dispatch(setSubStore({ openFlightTimeModal: false }))
            if (res.data) {
                window.location.reload();
            } else {
                dispatch(setInformModal({
                    icon: "remove circle",
                    header: "Fail",
                    conten: "Update flight time failed",
                    type: 2,
                    open: true
                }))
            }
            dispatch(setSubStore({ isShowLoader: false }))
        }).catch(err => {
            dispatch(setSubStore({ openFlightTimeModal: false }))
            dispatch(setSubStore({ isShowLoader: false }))
            dispatch(setInformModal({
                icon: "remove circle",
                header: "Fail",
                conten: "Update flight time failed",
                type: 2,
                open: true
            }))
            console.log(err);
        })
    }
}

export function setCurrentFlightTime(currentFlightTime) {
    return {
        type: actionType.SET_CURRENT_FLIGHT_TIME,
        currentFlightTime
    }
}

export function clearCurrentFlightTime() {
    return {
        type: actionType.CLEAR_CURRENT_FLIGHT_TIME
    }
}

export function setFlightBasicInfo(basicInfo) {
    return {
        type: actionType.SET_FLIGHT_BASIC_INFO,
        basicInfo
    }
}

export function setFlightTicketInfo(ticketInfo, index) {
    return {
        type: actionType.SET_FLIGHT_TICKET_INFO,
        ticketInfo,
        index
    }
}

export function clearFlightBasicInfo() {
    return {
        type: actionType.CLEAR_FLIGHT_BASIC_INFO
    }
}

export function clearFlightTicketInfo() {
    return {
        type: actionType.CLEAR_FLIGHT_TICKET_INFO
    }
}

export function insertFlight(flight, ticketClasses, token) {
    return dispatch => {
        let data = {
            flightId: flight.flightid,
            startPointId: flight.fromid,
            endPointId: flight.toid,
            flightDate: flight.date,
            startTimeStr: getShortTimeStr(flight.time.startTime),
            endTimeStr: getShortTimeStr(flight.time.endTime),
            flightNote: flight.note
        }
        const header = {
            'Authorization': 'Bearer ' + token
        }
        dispatch(setSubStore({ isShowLoader: true }))
        return callApi(env.INSERT_FLIGHT_ENDPOINT, "post", data, header).then(res => {
            if (res.data) {
                if (ticketClasses.length > 0) {
                    let sc = true;
                    ticketClasses.forEach(async val => {
                        val.flightId = flight.flightid;
                        try {
                            await callApi(env.INSERT_TICKET_CLASS_DETAIL_ENDPOINT, "post", val, header);
                        } catch (err) {
                            sc = false;
                            console.log(err);
                        }
                    });
                    if (sc) {
                        dispatch(clearFlightBasicInfo());
                        dispatch(clearFlightTicketInfo());
                        dispatch(setInformModal({
                            icon: "check circle",
                            header: "Success",
                            content: "Add flight successfully",
                            link: "/flight-management/add/1",
                            open: true
                        }))
                    } else {
                        dispatch(setInformModal({
                            icon: "remove circle",
                            header: "Fail",
                            conten: "Add flight failed",
                            type: 2,
                            open: true
                        }))
                    }
                    dispatch(setSubStore({ isShowLoader: false }))
                } else {
                    dispatch(setSubStore({ isShowLoader: false }))
                }
            } else {
                dispatch(setSubStore({ isShowLoader: false }))
            }
        }).catch(err => {
            console.log(err);
            dispatch(setSubStore({ isShowLoader: false }))
        })
    }
}

export function setInformModal(modalState) {
    return {
        type: actionType.SET_INFORM_MODAL,
        modalState
    }
}

export function setCurrentFlight(flight) {
    return {
        type: actionType.SET_CURRENT_FLIGHT,
        flight
    }
}

export function getFlightByFlightId(flightId) {
    return dispatch => {
        let endPoint = `${env.GET_FLIGHT_ENDPOINT}/${flightId}`;
        dispatch(setSubStore({ isShowLoader: true }));
        return callApi(endPoint).then(res => {
            if (res.data) {
                dispatch(setCurrentFlight(res.data))
            }
            dispatch(setSubStore({ isShowLoader: false }));
        }).catch(err => {
            dispatch(setSubStore({ isShowLoader: false }));
            console.log(err);
        })
    }
}

export function updateFlightStatus(flightStatus, flightId) {
    return dispatch => {
        let formData = new FormData();
        formData.append("flightStatus", flightStatus);
        formData.append("flightId", flightId);
        dispatch(setSubStore({ isShowLoader: true }));
        return callApi(env.UPDATE_FLIGHT_STATUS_ENDPOINT, "put", formData).then(res => {
            dispatch(setSubStore({ isShowLoader: false }));
        }).catch(err => {
            dispatch(setSubStore({ isShowLoader: false }));
            console.log(err);
        })
    }
}

export function setCurrentBookings(bookings) {
    return {
        type: actionType.SET_CURRENT_BOOKINGS,
        bookings
    }
}

export function getBookingByFlightId(flightId) {
    return dispatch => {
        let endPoint = `${env.BOOKING_ENDPOINT}/${flightId}`;
        dispatch(setSubStore({ isShowLoader: true }))
        return callApi(endPoint).then(res => {
            dispatch(setCurrentBookings(res.data))
            dispatch(setSubStore({ isShowLoader: false }))
        }).catch(err => {
            dispatch(setSubStore({ isShowLoader: false }))
            console.log(err)
        })
    }
}

export function setCurrentBooking(booking) {
    return {
        type: actionType.SET_CURRENT_BOOKING,
        booking
    }
}

export function getAllAdmin() {
    return dispatch => {
        dispatch(setSubStore({ isShowLoader: true }))
        return callApi(env.ADMIN_ENDPOINT).then(res => {
            dispatch(setCurrentEmployees(res.data));
            dispatch(setSubStore({isShowLoader:false}))
        }).catch(err => {
            dispatch(setSubStore({isShowLoader:false}))
            console.log(err)
        })
    }
}