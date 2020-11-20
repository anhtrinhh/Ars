import NotFound from "./pages/errors/not-found";
import PrivateRouteAction from "./components/util-components/private-route-action";
import Home from "./pages/home";
import Signin from "./pages/sign-in";
import FlightManagement from "./pages/flight-management";
import FlightSearch from "./pages/flight-management/flight-search";
import FlightAdd from "./pages/flight-management/flight-add";
import FlightDetail from "./pages/flight-management/flight-detail";
import EmployeeManagement from "./pages/employee-management";
import BookingManagement from "./pages/booking-management";
import FlightTimeManagement from "./pages/flight-time-management";
import FlightTimeDetail from "./pages/flight-time-management/flight-time-detail"


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
        path: "/flight-management/detail/:flightId",
        exact: true,
        page: FlightDetail
    },
    {
        path: "/flight-management/bookings/:flightId",
        exact: true,
        page: BookingManagement
    },
    {
        path: "/flight-time-management",
        exact: true,
        page: FlightTimeManagement
    },
    {
        path: "/flight-time-management/:from/:to",
        exact: true,
        page: FlightTimeDetail
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