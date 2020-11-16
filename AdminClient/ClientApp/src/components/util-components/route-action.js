import {Route} from "react-router-dom";

export default function RouteAction(route){
    return <Route 
            exact={route.exact}
            path={route.path} 
            render={props => <route.page {...props} routes={route.routes} />}
        />
}