import React from "react";
import "./style.scss"
import { Segment, Form, Header, Icon, Message } from "semantic-ui-react"
import { connect } from "react-redux";
import { signin } from "../../actions";

class Signin extends React.Component {
    constructor(props) {
        super(props);
        if (props.jwtToken) {
            props.history.goBack();
        }
        this.state = {
            erremail: null,
            errpassword: null,
            email: '',
            password: '',
            showSigninMessage: false
        }
    }
    validate(email, password) {
        let success = true;
        if (email.trim().length <= 0) {
            this.setState({
                erremail: "Please enter your email!"
            });
            success = false;
        }
        if (password.trim().length <= 0) {
            this.setState({
                errpassword: "Please enter your password!"
            })
            success = false;
        }
        return success;
    }
    showErrorSignin = () => {
        this.setState({
            showSigninMessage: true
        })
    }
    redirectTo = () => {
        let { history, location } = this.props;
        let { from } = location.state || { from: { pathname: "/" } };
        history.replace(from);
    }
    handleSubmit = evt => {
        let { email, password } = this.state;
        let success = this.validate(email, password);
        if (success) {
            this.props.checkSignin(this.redirectTo, this.showErrorSignin, {
                adminEmail: email,
                adminPassword: password
            })
        }
    }
    handleChangeInput = evt => {
        this.setState({
            [evt.target.name]: evt.target.value,
            ["err" + evt.target.name]: null,
            showSigninMessage: false
        })
    }
    render() {
        let { erremail, errpassword, showSigninMessage } = this.state;
        return (
            <div className="sign-wrapper">
                <Segment raised className="sign-form">
                    <div className="signin-icon">
                        <Icon name="user" />
                    </div>
                    <Header textAlign="center" size="huge" className="sign-title">Sign in</Header>
                    {
                        showSigninMessage
                            ? (<Message error>
                                <Message.Header>Sign in fail!</Message.Header>
                                <span>Signin information is incorrect.</span>
                            </Message>)
                            : ''
                    }
                    <Form>
                        <Form.Input fluid
                            label="Email"
                            placeholder="Email"
                            error={erremail}
                            name="email"
                            onChange={this.handleChangeInput}
                        />
                        <Form.Input fluid
                            label="Password"
                            placeholder="Password"
                            type="password"
                            name="password"
                            error={errpassword}
                            onChange={this.handleChangeInput}
                        />
                        <Form.Checkbox label='Remember me' />
                        <Header textAlign="center">
                            <Form.Button onClick={this.handleSubmit}>Sign in</Form.Button>
                        </Header>
                    </Form>
                </Segment>
            </div>
        )
    }
}

const mapDispatchToProps = dispatch => {
    return {
        checkSignin(resolve, reject, signInfo) {
            dispatch(signin(resolve, reject, signInfo))
        }
    }
}

const mapStateToProps = state => {
    return {
        jwtToken: state.account.jwtToken
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(Signin);