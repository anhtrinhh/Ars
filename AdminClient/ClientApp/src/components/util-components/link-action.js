import { Link, useRouteMatch } from "react-router-dom";

export default function LinkAction(props) {
    const match = useRouteMatch({
        path: props.to,
        exact: props.exact
    });
    let classN = props.className ? props.className : "";
    classN += (match ? " active" : "");
    return <li className="nav-item">
        <Link to={props.to} className={classN}>{props.children}</Link>
    </li>
}