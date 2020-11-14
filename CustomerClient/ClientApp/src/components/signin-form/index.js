import "./style.scss";
import Logo from "../../app/images/logo.png";
import SigninInfo from "./signin-info";

export default function SignInForm(props) {
    return (
        <div className="signin-form">
            <div className="signin-form__logo">
                <img src={Logo} alt="Logo" />
            </div>
            <div className="signin-form__description">
                <h3>Welcome to Ars Airways</h3>
            </div>
            <SigninInfo {...props} />
        </div>
    )
}