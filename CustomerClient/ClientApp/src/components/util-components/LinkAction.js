import { Link, useRouteMatch } from "react-router-dom";

export default function LinkAction(props){
    const match = useRouteMatch({
        path: props.to,
        exact: props.active
    });
    return <li className={match ? "active" : ""}>
        <Link to={props.to}>{props.label}</Link>
        {props.children}
    </li>
}