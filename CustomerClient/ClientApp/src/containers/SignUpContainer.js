import {connect} from "react-redux";
import {SaveCustomerBasicInfo,SaveCustomerContactInfo} from "../actions/signup-action";
import SignUp from "../pages/sign/signup";

const mapDispatchToProps = (dispatch, props) => {
    return {
        saveBasicInfo(basicInfo) {
            dispatch(SaveCustomerBasicInfo(basicInfo))
        },
        saveContactInfo(contactInfo) {
            dispatch(SaveCustomerContactInfo(contactInfo))
        }
    }
}

let SignUpContainer = connect(null, mapDispatchToProps)(SignUp);

export default SignUpContainer;

