import * as ActionType from "../constants/action-type";

let initFlight = {
    totalTicketPrice: 0,
    totalTex: 0,
    flightId: null,
    startTime: null,
    endTime: null,
    startPointId: null,
    endPointId: null,
    ticketClassDetailId: 0,
    ticketClassId: null,
    ticketClass: null,
    flightDate: null,
    tickets: [

    ]
}

let initTicket = {
    ticketPrice: 0,
    guestFirstName: null,
    guestLastName: null,
    guestGender: false,
    guestBirthday: ''
}

let initState = {
    numberAdults: 1,
    numberChildren: 0,
    numberInfants: 0,
    flights: [

    ]
};
let init = sessionStorage.getItem("booking-info") ? JSON.parse(sessionStorage.getItem("booking-info"))
    : initState;

let BookingInfo = (state = init, action) => {
    switch (action.type) {
        case ActionType.SET_NUMBER_GUEST:
            state = { ...state, ...action.numberGuest };
            sessionStorage.setItem("booking-info", JSON.stringify(state));
            return state;
        case ActionType.CLEAR_BOOKING_INFO:
            state = { ...initState };
            sessionStorage.setItem("booking-info", JSON.stringify(state));
            return state;
        case ActionType.SET_INIT_FLIGHT:
            state.flights = [];
            for (let i = 0; i < action.amount; i++) {
                let flight = { ...initFlight };
                flight.tickets = [];
                for (let a = 0; a < (state.numberAdults + state.numberChildren + state.numberInfants); a++) {
                    flight.tickets.push({ ...initTicket })
                }
                state.flights.push(flight)
            }
            sessionStorage.setItem("booking-info", JSON.stringify(state));
            return state;
        case ActionType.SET_TICKET:
            let { index, ticketClassDetail, flight } = action;
            state.flights[index].totalTex = 0;
            state.flights[index].tickets.forEach((val, ix) => {
                if (ix < state.numberAdults) {
                    val.ticketPrice = ticketClassDetail.adultTicketPrice;
                    state.flights[index].totalTex += ticketClassDetail.adultTex;
                } else if (ix >= state.numberAdults && ix < state.numberAdults + state.numberChildren) {
                    val.ticketPrice = ticketClassDetail.childTicketPrice;
                    state.flights[index].totalTex += ticketClassDetail.childTex;
                } else {
                    val.ticketPrice = ticketClassDetail.infantTicketPrice;
                    state.flights[index].totalTex += ticketClassDetail.infantTex;
                }
            });
            state.flights[index].totalTicketPrice = state.flights[index].tickets
                .reduce((total, val) => {
                    return total + val.ticketPrice;
                }, 0);
            state.flights[index].flightId = ticketClassDetail.flightId;
            state.flights[index].startTime = flight.startTime;
            state.flights[index].endTime = flight.endTime;
            state.flights[index].startPointId = flight.startPointId;
            state.flights[index].endPointId = flight.endPointId;
            state.flights[index].ticketClassId = ticketClassDetail.ticketClassId;
            state.flights[index].ticketClassDetailId = ticketClassDetail.ticketClassDetailId;
            state.flights[index].flightDate = flight.flightDate;
            state.flights[index].ticketClass = ticketClassDetail.ticketClassId.toUpperCase() === "ECO"
                ? "Ars Economy" : ticketClassDetail.ticketClassId.toUpperCase() === "PRE"
                    ? "Ars Premium" : "Ars Bussiness";
            sessionStorage.setItem("booking-info", JSON.stringify(state));
            return state;
        case ActionType.SET_GUEST_INFO:
            let { indexTicket, guestInfo } = action;
            state.flights.forEach(val => {
                val.tickets[indexTicket] = { ...val.tickets[indexTicket], ...guestInfo };
            });
            sessionStorage.setItem("booking-info", JSON.stringify(state));
            return state;
        default:
            return state;
    }
}


export default BookingInfo;