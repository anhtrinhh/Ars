import SignInForm from "../../components/signin-form";
import "./style.scss";

export default function SignIn(props) {
    return (
        <section className="sign-wrapper">
            <div className="signin-content">
                <SignInForm {...props} />
            </div>
        </section>
    )
}