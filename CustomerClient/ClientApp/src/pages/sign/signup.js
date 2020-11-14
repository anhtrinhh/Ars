import RouteAction from "../../components/util-components/RouteAction";
import { Switch, Redirect } from "react-router-dom";
import "./style.scss";

export default function SignUp(props) {
    let { location, match } = props;
    return (location.pathname === match.url) 
    ? <Redirect to={props.routes[0].path} /> 
    : props.routes.some(val => val.path === location.pathname) 
    ? (
        <section className="sign-wrapper">
            <div className="signup-content">
                <div className="signup-form">
                    <Switch>
                        {props.routes.map((route, ix) => <RouteAction key={ix} {...route} />)}
                    </Switch>
                </div>
            </div>
        </section>
    )
    : <Redirect to="/notfound"/>
}