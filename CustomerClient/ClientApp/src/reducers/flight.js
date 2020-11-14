import * as ActionType from "../constants/action-type";

let init = {
    totalPage: 1,
    flightPerView: 10,
    activePage: 1,
    flights: [],
    currentFlights: [],
    currentFlight: null
}

let Flight = (state = init, action) => {
    switch(action.type) {
        case ActionType.SET_FLIGHT:
            state.flights = action.flights;
            let tPage = parseFloat(action.flights.length / state.flightPerView);
            state.totalPage = (tPage > Math.floor(tPage)) ? (Math.floor(tPage) + 1) : tPage;
            state.currentFlights = action.flights.slice(0, state.flightPerView);
            console.log(state)
            return {...state};
        case ActionType.SET_CURRENT_FLIGHT:
            let start = (action.pageNumber - 1) * state.flightPerView;
            let end = start + state.flightPerView;
            state.currentFlights = state.flights.slice(start, end);
            return {...state};
        case ActionType.SET_CURR_FLIGHT:
            state.currentFlight = state.flights[action.index];
            return {...state};
        default:
            return state;
    }
}

export default Flight;