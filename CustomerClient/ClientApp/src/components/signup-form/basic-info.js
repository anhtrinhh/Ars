import { Form, Button, Label, Select } from "semantic-ui-react";
import SignUpStep from "./signup-step";
import { SaveSignUpInfo } from "../../actions/signup-action";
import { connect } from "react-redux";
import { useState } from "react";
import DatePickerCustom from "../../components/util-components/DatePickerCustom";
import FormatString from "../../utils/format-string";
import FormatDate from "../../utils/convertdate";


const genderOptions = [
    { key: 0, text: "Male", value: false },
    { key: 1, text: "Female", value: true }
]
function BasicInfo(props) {
    const {CustomerLastName, CustomerFirstName, CustomerBirthday, CustomerGender} = props.basicInfo;
    let [errorLastName, setErrorLastName] = useState(false);
    let [errorFirstName, setErrorFirstName] = useState(false);
    let [errorGender, setErrorGender] = useState(false);
    let [errorBirthday, setErrorBirthday] = useState(false);
    function checkValidate(lastname, firstname, birthday, gender) {
        let validate = true;
        if(lastname.trim().length <= 0) {
            setErrorLastName(true);
            validate = false;
        }
        if(firstname.trim().length <= 0) {
            setErrorFirstName(true);
            validate = false;
        }
        if(birthday.trim().length <= 0) {
            setErrorBirthday(true);
            validate = false;
        }
        if(gender !== true && gender !== false) {
            setErrorGender(true);
            validate = false;
        }
        return validate;
    }
    const handleClick = (evt) => {
        const validate = checkValidate(CustomerLastName, CustomerFirstName, CustomerBirthday, CustomerGender);
        if(validate) {
            props.history.push("/signup/contact-info", {from: props.location});
        }
    }

    const handleChangeFirstname = evt => {
        props.saveBasicInfo({
            CustomerFirstName: FormatString(evt.target.value)
        })
        setErrorFirstName(false);
    }

    const handleChangeLastname = evt => {
        props.saveBasicInfo({
            CustomerLastName: FormatString(evt.target.value)
        });
        setErrorLastName(false);
    }

    const handleChangeGender = (evt, data) => {
        props.saveBasicInfo({
            CustomerGender: data.value
        });
        setErrorGender(false);
    }

    const handleChangeBirthday = (date, evt) => {
        if(date != null) {
            props.saveBasicInfo({
                CustomerBirthday: FormatDate(date)
            })
        } else {
            props.saveBasicInfo({
                CustomerBirthday: ''
            })
        }
        setErrorBirthday(false);
    }
    return (
        <div>
            <SignUpStep step={1} />
            <div className="signup-form__description">
                <h3>Ready to sign up an account? Let’s get started</h3>
                <p>We need a few details about you to create your account profile.</p>
            </div>
            <Form>
                <Form.Field>
                    <label>Last name</label>
                    <input type="text"
                        value={CustomerLastName}
                        placeholder="Enter your last name"
                        onChange={handleChangeLastname}
                    />
                    {errorLastName 
                    ?(<Label pointing prompt>Please enter last name</Label>) 
                    : ''}
                </Form.Field>
                <Form.Field>
                    <label>First name</label>
                    <input type="text"
                        value={CustomerFirstName}
                        placeholder="Enter your first name"
                        onChange={handleChangeFirstname}
                    />
                    {errorFirstName
                    ?(<Label pointing prompt>Please enter first name</Label>) 
                    : ''}
                </Form.Field>
                <Form.Field>
                    <label>Birthday</label>
                    <DatePickerCustom
                        placeholderText="Enter your birthday"
                        selected={CustomerBirthday !== '' ? new Date(CustomerBirthday) : null}
                        onChange={handleChangeBirthday}
                    />
                    {errorBirthday 
                    ?(<Label pointing prompt>Please choose birthday</Label>) 
                    : ''}
                </Form.Field>
                <Form.Field>
                    <label>Gender</label>
                    <Select 
                        options={genderOptions}
                        placeholder="Choose your gender"
                        onChange={handleChangeGender}
                        value={CustomerGender}
                    />
                    {errorGender 
                    ?(<Label pointing prompt>Please choose gender</Label>) 
                    : ''}
                </Form.Field>
            </Form>
            <div className="btn-confirm">
                <Button color="green" size="large" onClick={handleClick}>Next</Button>
            </div>
        </div>
    )
}

const mapStateToProps = state => {
    return {
        basicInfo: state.SignUpInfo
    }
}

const mapDispatchToProps = (dispatch, props) => {
    return {
        saveBasicInfo(basicInfo) {
            dispatch(SaveSignUpInfo(basicInfo));
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(BasicInfo);