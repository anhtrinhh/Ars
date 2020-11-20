import * as actionType from "../constants/action-type";

let initState = {
    date: null,
    fromid: null,
    toid: null,
    flightid: '',
    time: null,
    note: ''
}

let flightBasicInfo = (state = initState, action) => {
    switch (action.type) {
        case actionType.SET_FLIGHT_BASIC_INFO:
            state = { ...action.basicInfo };
            return state;
        case actionType.CLEAR_FLIGHT_BASIC_INFO:
            state = {...initState};
            return state;
        default:
            return state;
    }
}

export default flightBasicInfo;