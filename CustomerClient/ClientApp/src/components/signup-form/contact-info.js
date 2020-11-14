import { Form, Divider, Button, Label } from "semantic-ui-react";
import SignUpStep from "./signup-step";
import { connect } from "react-redux";
import { useEffect, useState } from "react";
import { SaveSignUpInfo } from "../../actions/signup-action"
import FormatString from "../../utils/format-string";

function ContactInfo(props) {
    let { history, location } = props;
    let [errorPhone, setErrorPhone] = useState(null);
    let [errorEmail, setErrorEmail] = useState(null);
    let [errorIdentification, setErrorIdentification] = useState(null);
    let [errorAddress, setErrorAddress] = useState(null);
    let { CustomerFirstName, CustomerLastName, CustomerBirthday, CustomerEmail,
        CustomerPhoneNumber, CustomerIdentification, CustomerAddress } = props.SignUpInfo;
    useEffect(() => {
        if (!CustomerFirstName || !CustomerLastName || !CustomerBirthday) {
            history.goBack();
        }
    });
    const handleNext = (evt) => {
        const vali = validate(CustomerPhoneNumber, CustomerEmail, CustomerIdentification, CustomerAddress);
        if (vali) {
            history.push("/signup/confirm-info", { from: location });
        }
    }

    function validate(phone, email, identification, address) {
        const emailRegex = /^[\w!#$%&'*+/=?`{|}~^-]+(?:\.[\w!#$%&'*+/=?`{|}~^-]+)*@(?!-)(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}$/;
        const phoneRegex = /^\d{8,15}$/;
        const idRegex = /^\d{8,15}$/;
        let success = true;
        if (!emailRegex.test(email.trim())) {
            setErrorEmail("Email address is incorrect!");
            success = false;
        }
        if (!phoneRegex.test(phone.trim())) {
            setErrorPhone("Phone number is incorrect!");
            success = false;
        }
        if (!idRegex.test(identification.trim())) {
            setErrorIdentification("Identification is incorrect!");
            success = false;
        }
        if (address.trim() === '') {
            setErrorAddress("Please enter your address!");
            success = false;
        }
        if (address.trim().length < 3) {
            setErrorAddress("The address is too short!");
            success = false;
        }
        return success;
    }
    const handleBack = () => {
        history.push("/signup/basic-info")
    }
    const handleChangePhone = (evt) => {
        props.saveContactInfo({
            CustomerPhoneNumber: evt.target.value
        });
        setErrorPhone(null);
    }
    const handleChangeEmail = (evt) => {
        props.saveContactInfo({
            CustomerEmail: evt.target.value
        });
        setErrorEmail(null);
    }
    const handleChangeIdentification = (evt) => {
        props.saveContactInfo({
            CustomerIdentification: evt.target.value
        });
        setErrorIdentification(null);
    }
    const handleChangeAddress = (evt) => {
        props.saveContactInfo({
            CustomerAddress: FormatString(evt.target.value)
        });
        setErrorAddress(null);
    }
    return (
        <div>
            <SignUpStep step={2} />
            <div className="signup-form__description">
                <h3>What are your contact details?</h3>
                <p>Please fill out the fields below. We need your mobile phone and address details to make sure we can ship awards to you safely.</p>
            </div>
            <Divider />
            <div className="signup-form__description">
                <h3>Phone number</h3>
                <p>Enter either a mobile phone number or a business phone number below. Providing your mobile phone number indicates that you consent to receiving automated calls regarding flight details from ARS Airways.</p>
            </div>
            <Form>
                <Form.Field>
                    <label>Phone number</label>
                    <input type="text"
                        placeholder="Enter your phone number"
                        onChange={handleChangePhone}
                        value={CustomerPhoneNumber}
                    />
                    {errorPhone
                        ? (<Label pointing prompt>{errorPhone}</Label>)
                        : ''}
                </Form.Field>
                <Form.Field>
                    <label>Email</label>
                    <input type="text"
                        placeholder="Enter your email"
                        onChange={handleChangeEmail}
                        value={CustomerEmail}
                    />
                    {errorEmail
                        ? (<Label pointing prompt>{errorEmail}</Label>)
                        : ''}
                </Form.Field>
                <Form.Field>
                    <label>Identification</label>
                    <input type="text"
                        placeholder="Enter your identification"
                        onChange={handleChangeIdentification}
                        value={CustomerIdentification}
                    />
                    {errorIdentification
                        ? (<Label pointing prompt>{errorIdentification}</Label>)
                        : ''}
                </Form.Field>
                <Form.Field>
                    <label>Address</label>
                    <input type="text"
                        placeholder="Enter your address"
                        onChange={handleChangeAddress}
                        value={CustomerAddress}
                    />
                    {errorAddress
                        ? (<Label pointing prompt>{errorAddress}</Label>)
                        : ''}
                </Form.Field>
            </Form>
            <div className="btn-confirm">
                <Button color="black" size="large" onClick={handleBack}>Back</Button>
                <Button color="green" size="large" onClick={handleNext}>Next</Button>
            </div>
        </div>
    )
}

let mapStateToProps = state => {
    return {
        SignUpInfo: state.SignUpInfo
    }
}

let mapDispatchToProps = (dispatch, props) => {
    return {
        saveContactInfo(contactInfo) {
            dispatch(SaveSignUpInfo(contactInfo));
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(ContactInfo);