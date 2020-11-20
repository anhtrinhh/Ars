import * as actionType from "../constants/action-type";

let initState = null;

let currentBooking = (state =initState, action) => {
    switch(action.type) {
        case actionType.SET_CURRENT_BOOKING:
            state = {...action.booking};
            return state;
        default:
            return state;
    }
}

export default currentBooking;