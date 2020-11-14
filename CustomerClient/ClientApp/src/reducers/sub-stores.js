import * as ActionType from "../constants/action-type";

let init = {
    isSignin: true,
    isOpenModalBookingDetail: false,
    flightIndex: 0,
    isOpenModalBookingSuccess: false,
    isOpenModalBookingFail: false,
    modalInform: {
        state: false,
        inform: '',
        type: 0,
        title: ''
    },
    isOpenBookingDetailModal: false
}

let SubStore = (state = init, action) => {
    switch(action.type) {
        case ActionType.SET_SIGNIN:
            state.isSignin = action.isSignin;
            return {...state};
        case ActionType.SET_OPEN_BOOKING_DETAIL:
            state.isOpenModalBookingDetail = action.isOpenModal;
            return {...state};
        case ActionType.SET_MODAL:
            state = {...state, ...action.modalState};
            return state;
        case ActionType.SET_FLIGHT_INDEX:
            state.flightIndex = action.flightIndex;
            return {...state};
        case ActionType.SET_BOOKING_DETAIL_MODAL:
            state.isOpenBookingDetailModal = action.isOpenModal;
            return {...state};
        default:
            return state;
    }
}

export default SubStore;