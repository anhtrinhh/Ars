import { Route, Redirect } from "react-router-dom";
import {connect} from "react-redux";


function PrivateRouteAction(route) {
    let {adminEmail} = route;
    return (
        <Route
            exact={route.exact}
            path={route.path}
            render={props =>
                adminEmail ? (
                    <route.page {...props} routes={route.routes} />
                ) : (
                        <Redirect
                            to={{
                                pathname: "/signin",
                                state: { from: props.location }
                            }}
                        />
                    )
            }
        />
    );
}

const mapStateToProps = state => {
    return {
        adminEmail: state.account.adminEmail
    }
}

export default connect(mapStateToProps)(PrivateRouteAction);