import * as actionType from "../constants/action-type";
import * as env from "../constants/env";
import callApi from "../utils/api-util";
import {getShortTimeStr} from "../utils/datetime-utils"

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

export function getTimeSlot1(fromid, toid, flightdate, token) {
    return dispatch => {
        let endpoint = `${env.GET_REST_TIMESLOT_ENDPOINT}/${fromid}/${toid}/${flightdate}`; 
        dispatch(setSubStore({isShowLoader: true}))
        return callApi(endpoint, "get", null, {
            'Authorization': 'Bearer ' + token
        }).then(res => {
            dispatch(setRestTimeSlot(res.data))
            dispatch(setSubStore({isShowLoader: false}))
        }).catch(err => {
            console.log(err)
            dispatch(setSubStore({isShowLoader: false}))
        })
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
        dispatch(setSubStore({isShowLoader: true}))
        return callApi(env.INSERT_FLIGHT_ENDPOINT, "post", data, header).then(res => {
            if(res.data) {
                if(ticketClasses.length > 0) {
                    let sc = true;
                    ticketClasses.forEach(async val => {
                        val.flightId = flight.flightid;
                        try {
                            await callApi(env.INSERT_TICKET_CLASS_DETAIL_ENDPOINT, "post", val, header);
                        } catch(err) {
                            sc = false;
                            console.log(err);
                        }
                    });
                    if(sc) {

                    } else {
                        
                    }
                    dispatch(setSubStore({isShowLoader: false}))
                } else {
                    dispatch(setSubStore({isShowLoader: false}))
                }
            } else {
                dispatch(setSubStore({isShowLoader: false}))
            }
        }).catch(err => {
            console.log(err);
            dispatch(setSubStore({isShowLoader: false}))
        })
    }
}