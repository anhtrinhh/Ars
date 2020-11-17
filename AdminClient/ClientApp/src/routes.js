import NotFound from "./pages/errors/not-found";
import PrivateRouteAction from "./components/util-components/private-route-action";
import Home from "./pages/home";
import Signin from "./pages/sign-in";
import FlightManagement from "./pages/flight-management";
import FlightSearch from "./pages/flight-management/flight-search";
import FlightAdd from "./pages/flight-management/flight-add";
import EmployeeManagement from "./pages/employee-management";


export const PRIVATE_ROUTES = [
    {
        path: "/",
        exact: true,
        page: Home
    },
    {
        path: "/flight-management",
        exact: true,
        page: FlightManagement
    },
    {
        path: "/flight-management/:from/:to/:flightDate",
        exact: true,
        page: FlightSearch
    },
    {
        path: "/flight-management/add/:step(1|2|3)",
        exact: true,
        page: FlightAdd
    },
    {
        path: "/employee-management",
        exact: true,
        page: EmployeeManagement
    },
    {
        path: "*",
        exact: false,
        page: NotFound
    }
]

export const MAIN_ROUTES = [
    {
        path: "/",
        exact: true,
        page: PrivateRouteAction
    },
    {
        path: "/signin",
        exact: true,
        page: Signin
    },
    {
        path: "*",
        exact: false,
        page: NotFound
    }
]