import * as actionType from "../constants/action-type";
import * as env from "../constants/env";
import callApi from "../utils/api-util";

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