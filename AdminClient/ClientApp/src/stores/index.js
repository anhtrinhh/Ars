import {combineReducers} from 'redux';
import account from "./account";
import subStore from "./sub-store";
import flightDirection from "./flight-direction"
import currentFlights from "./current-flights";
import currentFlight from "./current-flight";
import timeslot from "./timeslot";
import flightBasicInfo from "./flight-basic-info"
import flightTicketInfo from  "./flight-ticket-info";
import informModal from "./inform-modal";
import currentBookings from "./current-bookings";
import currentBooking from "./current-booking";
import currentFlightTimes from "./current-flight-times";
import currentFlightTime from "./current-flight-time";
import currentAccount from "./current-account";
import currentAccounts from "./current-accounts";
 
let appStore = combineReducers({
    account,
    subStore,
    flightDirection,
    currentFlights,
    currentFlight,
    timeslot, 
    flightBasicInfo,
    flightTicketInfo,
    informModal,
    currentBookings,
    currentBooking,
    currentFlightTimes,
    currentFlightTime,
    currentAccount,
    currentAccounts
});

export default appStore;