import * as actionType from "../constants/action-type";

let initState = {
    adminId: '',
    adminFirstName: '',
    adminLastName: '',
    adminEmail: '',
    adminPhoneNumber: '',
    adminGender: false,
    adminBirthday: null,
    adminRights: 2,
    adminPassword: ''
}

let currentAccount = (state = initState, action) => {
    switch(action.type) {
        default:
            return state;
    }
}

export default currentAccount;