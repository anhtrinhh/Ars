import { connect } from "react-redux";
import SignUpStep from "./signup-step";
import { Icon, Button } from "semantic-ui-react";
import { Link } from "react-router-dom";
import { useEffect } from "react";
import ApiCaller from "../../utils/apicaller";
import {ClearSignUpInfo, SetLoader} from "../../actions/signup-action";


function ConfirmInfo(props) {
    let { history, location, signUpInfo, setLoader } = props;
    useEffect(() => {
        const vali = validate(signUpInfo);
        if (!vali) {
            if (location.state && location.pathname !== "/signup/confirm-info") {
                history.push(location.state.from, { from: location })
            } else {
                history.push("/", { from: location })
            }
        }
    });
    const handleConfirm = () => {
        const vali = validate(signUpInfo);
        if(vali) {
            setLoader(true);
            ApiCaller("customeraccount/signup", "post", {
                CustomerFirstName: signUpInfo.CustomerFirstName.trim(),
                CustomerLastName: signUpInfo.CustomerLastName.trim(),
                CustomerGender: signUpInfo.CustomerGender,
                CustomerBirthday: signUpInfo.CustomerBirthday.trim(),
                CustomerEmail: signUpInfo.CustomerEmail.trim(),
                CustomerIdentification: signUpInfo.CustomerIdentification.trim(),
                CustomerAddress: signUpInfo.CustomerAddress.trim(),
                CustomerPhoneNumber: signUpInfo.CustomerPhoneNumber.trim()
            }).then(res => {
                if(res.data) {
                    history.push("/signup/success");
                    props.clearSignUpInfo();
                    setLoader(false);
                }
            }).catch(err => {
                console.log(err);
                setLoader(false);
            });
        }
    }
    return (
        <div>
            <SignUpStep step={3} />
            <div className="signup-form__description">
                <h3>Confirm!</h3>
            </div>
            <div className="signup-form__confirm">
                <div className="signup-form__row">
                    <div className="col-4">
                        <p><span>1</span> Personal information.</p>
                    </div>
                    <div className="col-6">
                        <p><Link to="/signup/basic-info"><Icon name="pencil" /></Link></p>
                    </div>
                </div>
                <div className="signup-form__row">
                    <div className="col-4">
                        <p>Name:</p>
                    </div>
                    <div className="col-6">
                        <p className="bold">{(signUpInfo.CustomerFirstName + ' ' + signUpInfo.CustomerLastName).toUpperCase()}</p>
                    </div>
                </div>
                <div className="signup-form__row">
                    <div className="col-4">
                        <p>Date of birth:</p>
                    </div>
                    <div className="col-6">
                        <p className="bold">{signUpInfo.CustomerBirthday}</p>
                    </div>
                </div>
                <div className="signup-form__row">
                    <div className="col-4">
                        <p>Gender:</p>
                    </div>
                    <div className="col-6">
                        <p className="bold">{signUpInfo.CustomerGender ? 'Female' : 'Male'}</p>
                    </div>
                </div>
            </div>
            <div className="signup-form__confirm">
                <div className="signup-form__row">
                    <div className="col-4">
                        <p><span>2</span> Contact details.</p>
                    </div>
                    <div className="col-6">
                        <p><Link to="/signup/contact-info"><Icon name="pencil" /></Link></p>
                    </div>
                </div>
                <div className="signup-form__row">
                    <div className="col-4">
                        <p>Phone number:</p>
                    </div>
                    <div className="col-6">
                        <p className="bold">{signUpInfo.CustomerPhoneNumber}</p>
                    </div>
                </div>
                <div className="signup-form__row">
                    <div className="col-4">
                        <p>Email:</p>
                    </div>
                    <div className="col-6">
                        <p className="bold">{signUpInfo.CustomerEmail}</p>
                    </div>
                </div>
                <div className="signup-form__row">
                    <div className="col-4">
                        <p>Identification:</p>
                    </div>
                    <div className="col-6">
                        <p className="bold">{signUpInfo.CustomerIdentification}</p>
                    </div>
                </div>
                <div className="signup-form__row">
                    <div className="col-4">
                        <p>Address:</p>
                    </div>
                    <div className="col-6">
                        <p className="bold">{signUpInfo.CustomerAddress}</p>
                    </div>
                </div>
            </div>
            <div className="signup-form__btn-confirm">
                <Button color="green" size="large" onClick={handleConfirm}>Confirm</Button>
            </div>
        </div>
    );
}

function validate(signUpInfo) {
    let { CustomerFirstName, CustomerLastName, CustomerEmail, CustomerGender,
        CustomerPhoneNumber, CustomerAddress, CustomerIdentification, CustomerBirthday } = signUpInfo;
    const emailRegex = /^[\w!#$%&'*+/=?`{|}~^-]+(?:\.[\w!#$%&'*+/=?`{|}~^-]+)*@(?!-)(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}$/;
    const phoneRegex = /^\d{8,15}$/;
    const idRegex = /^\d{8,15}$/;
    let success = true;
    if (!emailRegex.test(CustomerEmail.trim())) {
        success = false;
    }
    if (!phoneRegex.test(CustomerPhoneNumber.trim())) {
        success = false;
    }
    if (!idRegex.test(CustomerIdentification.trim())) {
        success = false;
    }
    if (CustomerAddress.trim() === '') {
        success = false;
    }
    if (CustomerAddress.trim().length < 3) {
        success = false;
    }
    if (CustomerLastName.trim().length <= 0) {
        success = false;
    }
    if (CustomerFirstName.trim().trim().length <= 0) {
        success = false;
    }
    if (CustomerBirthday.trim().length <= 0) {
        success = false;
    }
    if (CustomerGender !== false && CustomerGender !== true) {
        success = false;
    }
    return success;
}

let mapStateToProps = state => {
    return {
        signUpInfo: state.SignUpInfo
    }
}

let mapDispatchToProps = (dispatch, props) => {
    return {
        clearSignUpInfo() {
            dispatch(ClearSignUpInfo())
        },
        setLoader(loaderState) {
            dispatch(SetLoader(loaderState))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(ConfirmInfo);


