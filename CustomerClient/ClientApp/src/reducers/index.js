import {combineReducers} from 'redux';
import SignUpInfo from "./signup-info";
import LoaderState from "./loader-state";
import Customer from "./customer";
import FLightDirection from "./flight-direction";
import BookingInfo from "./booking-info";
import Cart from "./cart";
import SubStore from "./sub-stores";
import BankCard from "./bank-card";
import ErrorBankCard from "./error-bank-card";
import Flight from "./flight";

let AppReducer = combineReducers({
    SignUpInfo,
    LoaderState,
    Customer,
    FLightDirection,
    BookingInfo,
    Cart,
    SubStore,
    BankCard,
    ErrorBankCard,
    Flight
});

export default AppReducer;