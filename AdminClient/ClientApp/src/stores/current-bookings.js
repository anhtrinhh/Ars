import * as actionType from "../constants/action-type";


let initState = [];

let currentBookings = (state=initState, action) => {
    switch(action.type) {
        case actionType.SET_CURRENT_BOOKINGS:
            state = [...action.bookings];
            return state;
        default:
            return state;
    }
}

export default currentBookings;