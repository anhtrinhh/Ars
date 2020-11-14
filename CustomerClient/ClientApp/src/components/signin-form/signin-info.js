import { Form, Message, Label } from "semantic-ui-react";
import { Link } from "react-router-dom";
import React, { Fragment } from "react";
import FormatString from "../../utils/format-string";
import ApiCaller from "../../utils/apicaller";
import {connect} from "react-redux";
import {SetLoader, GetCustomer, ClearCurrentCustomer} from "../../actions";

class SignInInfo extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            password: '',
            signin: '',
            remember: false,
            error: false,
            errorpassword: null,
            errorsignin: null
        }
    }
    componentDidMount() {
        this.props.clearCustomer();
    }
    handleClick = evt => {
        const success = this.validate(this.state.signin, this.state.password);
        if(success) {
            this.props.setLoader(true);
            ApiCaller("customeraccount/signin", "post", {
                CustomerEmail: this.state.signin,
                CustomerPassword: this.state.password
            }).then(res => {
                if(this.state.remember) {
                    localStorage.setItem("token", res.data.token);
                } else {
                    sessionStorage.setItem("token", res.data.token);
                }
                this.props.getCustomer(res.data.token);
                this.props.setLoader(false);
                if(this.props.location.state) {
                    this.props.history.replace(this.props.location.state.from);
                }else {
                    this.props.history.replace("/");
                }
            }).catch(err => {
                console.log(err);
                this.setState({
                    error: true
                }, () => {
                    this.props.setLoader(false);
                })
            })
        }
    }
    handleChange = evt => {
        this.setState({
            [evt.target.name]: FormatString(evt.target.value.trim()),
            ["error"+evt.target.name]: null
        })
    }
    handleChangeRemember = (evt, data) => {
        this.setState({
            remember: data.checked
        });
    }
    validate = (signin, password) => {
        let success = true;
        if(signin.length <= 0) {
            this.setState({
                errorsignin: "Please enter signin!"
            });
            success = false;
        }
        if(password.length <= 0) {
            this.setState({
                errorpassword: "Please enter password!"
            });
            success = false;
        }
        return success;
    }
    render() {
        return (
            <Fragment>
                {this.state.error ? (
                    <Message error>
                        <Message.Header>Sign in fail!</Message.Header>
                        <span>Signin information is incorrect.</span>
                    </Message>
                ): ''}
                <Form>
                    <Form.Field>
                        <label>Email or cell</label>
                        <input type="text"
                            placeholder="Email or cell"
                            name="signin"
                            value={this.state.signin}
                            onChange={this.handleChange}
                        />
                        {this.state.errorsignin
                        ? (<Label pointing prompt>{this.state.errorsignin}</Label>)
                        : ''}
                    </Form.Field>
                    <Form.Field>
                        <label>Password</label>
                        <input type="password"
                            name="password"
                            placeholder="password"
                            value={this.state.password}
                            onChange={this.handleChange}
                        />
                        {this.state.errorpassword
                        ? (<Label pointing prompt>{this.state.errorpassword}</Label>)
                        : ''}
                    </Form.Field>
                    <div className="remember-me">
                        <Form.Checkbox label="Remember me"
                            name="remember"
                            onChange={this.handleChangeRemember}
                        />
                        <Link to="forgot-password">Forgot password</Link>
                    </div>
                    <div className="signin-form__submit">
                        <Form.Button color="green" size="large" onClick={this.handleClick}>Sign In</Form.Button>
                    </div>
                </Form>
            </Fragment>
        )
    }
}

const mapDispatchToProps = (dispatch, props) => {
    return {
        setLoader(loaderState){
            dispatch(SetLoader(loaderState))
        },
        getCustomer(token) {
            dispatch(GetCustomer(token))
        },
        clearCustomer() {
            dispatch(ClearCurrentCustomer())
        }
    }
}

export default connect(null, mapDispatchToProps)(SignInInfo);