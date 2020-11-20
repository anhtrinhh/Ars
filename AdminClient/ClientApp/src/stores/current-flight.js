import * as actionType from "../constants/action-type";

let initState = {
    flightId: '',
    startTime: null,
    endTime: null,
    flightStatus: false,
    flightDate: '',
    flightNote: '',
    startPointId: '',
    endPointId: '',
    ticketClassDetail: []
}

let currentFlight = (state = initState, action) => {
    switch(action.type) {
        case actionType.SET_CURRENT_FLIGHT:
            state = {...state, ...action.flight};
            return state;
        default:
            return state;
    }
}

export default currentFlight;