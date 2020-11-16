import * as actionType from "../constants/action-type";

let initState = [];

let currentFlights = (state = initState, action) => {
    switch(action.type) {
        case actionType.SET_CURRENT_FLIGHTS:
            state = action.flights[0] ? [...action.flights[0]] : [];
            return state;
        default:
            return state;
    }
}

export default currentFlights;