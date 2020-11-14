import "./style.scss";
import Congrats from "./images/congrats.png";
import { Link } from "react-router-dom";
import { Button } from "semantic-ui-react";

export default function SignUpSuccess() {
    return (
        <div className="signup-inform">
            <img src={Congrats} alt="Success" />
            <p>Congratulation on the successful registration!
                        <br />
                       Please verify the link in your mailbox!</p>
            <Link to="/">
                <Button size="large" color="green">Return to home page</Button>
            </Link>
        </div>
    )
}