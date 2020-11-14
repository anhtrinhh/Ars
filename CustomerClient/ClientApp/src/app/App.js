import { BrowserRouter as Router, Switch } from 'react-router-dom';
import { MAIN_ROUTE } from "../routes";
import RouteAction from "../components/util-components/RouteAction";
import Header from "../components/header";
import Footer from "../components/footer";
import 'semantic-ui-css/semantic.min.css'
import "react-datepicker/dist/react-datepicker.css";
import "./styles/app.scss";
import Loader from "../components/loader";
import {connect} from "react-redux";

function App(props) {
  return (
    <Router>
      <Header />
      <Switch>
        {
          MAIN_ROUTE.map((route, index) => <RouteAction key={index} {...route} />)
        }
      </Switch>
      <Footer />
      {
        props.loaderState ? <Loader /> : ''
      }
    </Router>
  );
}

const mapStateToProps = state => {
  return {
    loaderState: state.LoaderState
  }
}

export default connect(mapStateToProps, null)(App);
