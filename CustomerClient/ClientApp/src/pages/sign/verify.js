import "./style.scss";
import VerifyFrom from "../../components/signup-form/verify-form";

export default function VerifySignUp(props) {
    return (
        <section className="sign-wrapper">
            <div className="signup-content">
                <div className="signup-form">
                    <VerifyFrom {...props} />
                </div>
            </div>
        </section >
    )
}