import React from "react"
import { Form, Label } from "semantic-ui-react"
import {connect} from "react-redux";
import {UpdateCustomerPassword} from "../../actions"

class ChangePassword extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            errcurrentpassword: null,
            errpassword: null,
            errrepassword: null,
            currentpassword: '',
            password: '',
            repassword: ''
        }
    }
    validate(currentpassword, password, repassword) {
        let success = true;
        if (currentpassword.trim().length <= 0) {
            this.setState({
                errcurrentpassword: "Please enter current password!"
            });
            success = false;
        }
        if (password.trim().length <= 0) {
            this.setState({
                errpassword: "Please enter password!"
            });
            success = false;
        }
        if (password.trim() !== repassword.trim()) {
            this.setState({
                errrepassword: "Does not match your password!"
            });
            success = false;
        }
        return success;
    }
    handleChange = evt => {
        this.setState({
            [evt.target.name]: evt.target.value.trim(),
            ["err" + evt.target.name]: null
        })
    }
    handleSubmit = evt => {
        let {currentpassword, repassword, password} = this.state;
        let validate = this.validate(currentpassword, password, repassword);
        if(validate) {
            let formData = new FormData();
            formData.append("customerPassword", password);
            formData.append("currentPassword", currentpassword);
            this.props.updatePassword(formData);
        }
    }
    render() {
        let {errrepassword, errcurrentpassword, errpassword, currentpassword,
        repassword, password} = this.state;
        return (
            <Form>
                <Form.Field width="8">
                    <label>Current password: </label>
                    <input type="password"
                        placeholder="Current password"
                        name="currentpassword"
                        value={currentpassword}
                        onChange={this.handleChange}
                    />
                    {errcurrentpassword
                            ? (<Label pointing prompt>{errcurrentpassword}</Label>)
                            : ''}
                </Form.Field>
                <Form.Field width="8">
                    <label>New password:</label>
                    <input type="password"
                        placeholder="New password"
                        name="password"
                        value={password}
                        onChange={this.handleChange}
                    />
                    {errpassword
                            ? (<Label pointing prompt>{errpassword}</Label>)
                            : ''}
                </Form.Field>
                <Form.Field width="8">
                    <label>Confirm password:</label>
                    <input type="password"
                        placeholder="Confirm password"
                        name="repassword"
                        value={repassword}
                        onChange={this.handleChange}
                    />
                    {errrepassword
                            ? (<Label pointing prompt>{errrepassword}</Label>)
                            : ''}
                </Form.Field>
                <Form.Button size="large" color="green" onClick={this.handleSubmit}>Update</Form.Button>
            </Form>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return {
        updatePassword(password) {
            dispatch(UpdateCustomerPassword(password))
        }
    }
}

export default connect(null, mapDispatchToProps)(ChangePassword);