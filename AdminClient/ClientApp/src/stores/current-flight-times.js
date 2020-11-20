import * as actionType from "../constants/action-type";

let initState = [];

let currentFlightTimes = (state = initState, action) => {
    switch(action.type) {
        case actionType.SET_CURRENT_FLIGHT_TIMES:
            state = [...action.flightTimes];
            return state;
        default:
            return state;
    }
}

export default currentFlightTimes;