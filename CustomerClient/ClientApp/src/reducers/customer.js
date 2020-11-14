import * as ActionType from "../constants/action-type";
import {API_URL} from "../constants/env";

let init = {
    customerNo: '',
    customerFirstName: '',
    customerLastName: '',
    customerEmail: '',
    customerPhoneNumber: '',
    customerGender: false,
    customerBirthday: null,
    customerIdentification: '',
    customerAddress: '',
    customerAvatar: ''
}; 

let Customer = (state = init, action) => {
    switch (action.type) {
        case ActionType.SET_CURRENT_CUSTOMER:
            state = {...state,...action.customer};
            if(!/^http/.test(state.customerAvatar)) {
                state.customerAvatar = API_URL + "/upload/customer/" + state.customerAvatar;
            }
            return {...state};
        case ActionType.CLEAR_CURRENT_CUSTOMER:
            state = {...init};
            if(sessionStorage.getItem("token")) {
                sessionStorage.removeItem("token")
            }
            if(localStorage.getItem("token")) {
                localStorage.removeItem("token")
            }
            return state;
        default:
            return state;
    }
}

export default Customer;

