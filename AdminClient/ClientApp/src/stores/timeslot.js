import * as actionType from "../constants/action-type";

let initState = [];

let timeslot = (state = initState, action) => {
    switch(action.type) {
        case actionType.SET_REST_TIME_SLOT:
            state = [...action.timeSlots];
            return [...state];
        default:
            return state;
    }
}

export default timeslot;