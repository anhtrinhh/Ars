import BasicInfo from "./basic-info";
import SignUpStep from "./signup-step";
import "./signup-form.scss";


export default function SignUpForm(props) {
    console.log(props)
    return (
        <div className="signup-form">
            <SignUpStep />
            <BasicInfo />
        </div>
    )
}