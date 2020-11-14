import Home from "../pages/home";
import SignUp from "../pages/sign/signup";
import SignIn from "../pages/sign/signin";
import BasicInfo from "../components/signup-form/basic-info";
import ContactInfo from "../components/signup-form/contact-info";
import ConfirmInfo from "../components/signup-form/confirm-info";
import NotFound from "../pages/errors/NotFound";
import SignUpSuccess from "../pages/sign/signup-success";
import VerifySignUp from "../pages/sign/verify";
import ChooseFlight from "../pages/booking/choose-flight";
import GuestInfo from "../pages/booking/guest-info";
import Booking from "../pages/booking";
import Profile from "../pages/account/profile";
import MyFlight from "../pages/account/myflight";
import Payment from "../pages/booking/payment";
import TestPage from "../pages/testpage";

export const MAIN_ROUTE = [
    {
        path: "/",
        exact: true,
        component: Home
    }, 
    {
        path: "/signup",
        component: SignUp,
        exact: false,
        routes: [
            {
                path: "/signup/basic-info",
                exact: true,
                component: BasicInfo
            },
            {
                path: "/signup/contact-info",
                exact: true,
                component: ContactInfo
            },
            {
                path: "/signup/confirm-info",
                exact: true,
                component: ConfirmInfo
            },
            {
                path: "/signup/success",
                exact: true,
                component: SignUpSuccess
            }
        ]
    },
    {
        path: "/active-account/:param",
        exact: true,
        component: VerifySignUp
    },
    {
        path: "/signin",
        exact: true,
        component: SignIn
    },
    {
        path: "/booking",
        exact: false,
        component: Booking,
        routes: [
            {
                path: "/booking/flights",
                exact: true,
                component: ChooseFlight
            },
            {
                path: "/booking/guest-info",
                exact: true,
                component: GuestInfo
            },
            {
                path: "/booking/payment",
                exact: true,
                component: Payment
            },
        ]
    },
    {
        path: "/profile",
        exact: true,
        component: Profile
    },
    {
        path: "/myflights",
        exact: true,
        component: MyFlight
    },
    {
        path: "/testpage",
        exact: true,
        component: TestPage
    },
    {
        path: "*",
        exact: false,
        component: NotFound
    }
];
