import {combineReducers} from 'redux';
import account from "./account";
import subStore from "./sub-store";
import flightDirection from "./flight-direction"
import currentFlights from "./current-flights";

let appStore = combineReducers({
    account,
    subStore,
    flightDirection,
    currentFlights
});

export default appStore;