import {combineReducers} from 'redux';
import account from "./account";
import subStore from "./sub-store";
import flightDirection from "./flight-direction"
import currentFlights from "./current-flights";
import timeslot from "./timeslot";
import flightBasicInfo from "./flight-basic-info"
import flightTicketInfo from  "./flight-ticket-info";
 
let appStore = combineReducers({
    account,
    subStore,
    flightDirection,
    currentFlights,
    timeslot, 
    flightBasicInfo,
    flightTicketInfo
});

export default appStore;