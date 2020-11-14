import { Form, Button, Label, Message } from "semantic-ui-react";
import React from "react";
import ApiCaller from "../../utils/apicaller";
import { connect } from "react-redux";
import { SetLoader } from "../../actions";

class VerifyForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            password: '',
            repassword: '',
            mbno: '',
            errorpassword: '',
            errorrepassword: '',
            errormbno: '',
            error: false
        }
    }
    handleChange = evt => {
        this.setState({
            [evt.target.name]: evt.target.value,
            ["error" + evt.target.name]: ''
        });
    }
    handleSubmit = evt => {
        evt.preventDefault();
        let { history, match } = this.props;
        const success = this.validate(this.state.password, this.state.repassword, this.state.mbno);
        if (success) {
            const { param } = match.params;
            this.props.setLoader(true);
            ApiCaller("customeraccount/activeaccount/" + param, "post", {
                CustomerNo: this.state.mbno,
                CustomerPassword: this.state.password
            }).then(res => {
                if (res.data) {
                    history.replace("/signin")
                } else {
                    this.setState({
                        error: true
                    })
                }
                this.props.setLoader(false);
            }).catch(err => {
                console.log(err);
                this.props.setLoader(false);
                this.setState({
                    error: true
                })
            })
        }
    }
    validate(password, repassword, mbno) {
        let success = true;
        if (password.trim().length <= 0) {
            this.setState({
                errorpassword: "Please enter password!"
            });
            success = false;
        }
        if (password.trim() !== repassword.trim()) {
            this.setState({
                errorrepassword: "Does not match your password!"
            });
            success = false;
        }
        if (mbno.trim().length <= 0) {
            this.setState({
                errormbno: "Please enter membership number!"
            });
            success = false;
        }
        return success;
    }
    render() {
        let { password, repassword, mbno, errormbno, errorpassword, errorrepassword, error } = this.state;
        return (
            <div>
                <div className="signup-form__description">
                    <h3>Verify</h3>
                </div>
                {error 
                ?(<Message error>
                    <Message.Header>Action Fail!</Message.Header>
                    <span>An error occurred or your account has been activated.</span>
                </Message>) : ''}
                <Form>
                    <Form.Field>
                        <label>Password</label>
                        <input type="password"
                            placeholder="Enter your password"
                            name="password"
                            onChange={this.handleChange}
                            value={password}
                        />
                        {errorpassword
                            ? (<Label pointing prompt>{errorpassword}</Label>)
                            : ''}
                    </Form.Field>
                    <Form.Field>
                        <label>Confirm password</label>
                        <input type="password"
                            placeholder="Enter confirm password"
                            name="repassword"
                            onChange={this.handleChange}
                            value={repassword}
                        />
                        {errorrepassword
                            ? (<Label pointing prompt>{errorrepassword}</Label>)
                            : ''}
                    </Form.Field>
                    <Form.Field>
                        <label>Membership number</label>
                        <input type="text"
                            placeholder="Enter your membership number"
                            name="mbno"
                            onChange={this.handleChange}
                            value={mbno}
                        />
                        {errormbno
                            ? (<Label pointing prompt>{errormbno}</Label>)
                            : ''}
                    </Form.Field>
                </Form>
                <div className="signup-form__btn-confirm">
                    <Button color="green" size="large" onClick={this.handleSubmit}>Confirm</Button>
                </div>
            </div>
        )
    }
}

const mapDispatchToProps = (dispatch, props) => {
    return {
        setLoader(loaderState) {
            dispatch(SetLoader(loaderState))
        }
    }
}

export default connect(null, mapDispatchToProps)(VerifyForm);