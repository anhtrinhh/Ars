import * as actionType from "../constants/action-type";

let init = sessionStorage.getItem("flight-direction") ? JSON.parse(sessionStorage.getItem("flight-direction")) : null;

let flightDirection = (state = init, action) => {
    switch(action.type) {
        case actionType.SET_FLIGHT_DIRECTION:
            state = {...action.flightDirection};
            sessionStorage.setItem("flight-direction", JSON.stringify(state));
            return state;
        default:
            return state;
    }
}

export default flightDirection;