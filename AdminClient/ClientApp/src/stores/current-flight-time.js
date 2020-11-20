import * as actionType from "../constants/action-type"

let initState = null;

let currentFlightTime = (state=initState, action) => {
    switch(action.type) {
        case actionType.SET_CURRENT_FLIGHT_TIME:
            state = {...action.currentFlightTime};
            return state;
        case actionType.CLEAR_CURRENT_FLIGHT_TIME:
            state = initState;
            return state;
        default:
            return state;
    }
}

export default currentFlightTime;