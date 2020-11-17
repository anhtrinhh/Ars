import * as actionType from "../constants/action-type";

let init = {
    ticketClassId: null,
	flightId: null,
	adultTicketPrice: '',
	childTicketPrice: '',
	infantTicketPrice: '',
	adultTex: '',
	childTex: '',
	infantTex: '',
	numberTicket: ''
}

let initState = [{...init}, {...init}, {...init}];

initState[0].ticketClassId= 'ECO';
initState[1].ticketClassId= 'PRE';
initState[2].ticketClassId= 'BUS';

let flightTicketInfo = (state = initState, action) => {
    switch(action.type) {
        case actionType.SET_FLIGHT_TICKET_INFO:
            state[action.index] = {...state[action.index], ...action.ticketInfo};
            return [...state];
        default:
            return state;
    }
}

export default flightTicketInfo;