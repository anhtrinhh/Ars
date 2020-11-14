import * as ActionType from "../constants/action-type";

let LoaderState = (state = false, action) => {
    switch (action.type) {
        case ActionType.SET_LOADER:
            state = action.loaderState;
            return state;
        default:
            return state;
    }
}

export default LoaderState;