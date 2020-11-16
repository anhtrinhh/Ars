import React from "react";
import { BrowserRouter as Router, Switch } from 'react-router-dom';
import { MAIN_ROUTES } from "./routes";
import RouteAction from "./components/util-components/route-action";
import Loader from "./components/loader";
import 'semantic-ui-css/semantic.min.css'
import "./app.scss";
import { connect } from "react-redux";
import SideBar from "./components/side-bar";
import Header from "./components/header";
import { PRIVATE_ROUTES } from "./routes";
import PrivateRouteAction from "./components/util-components/private-route-action";


class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      sidebarCollapse: false
    }
  }
  setSidebarCollapse = isCollapse => {
    this.setState({
      sidebarCollapse: isCollapse
    })
  }
  render() {
    let { sidebarCollapse } = this.state;
    let { jwtToken, isShowLoader } = this.props;
    return !jwtToken ? (
      <Router>
        <Switch>
          {
            MAIN_ROUTES.map((route, index) => <RouteAction key={index} {...route} />)
          }
        </Switch>
        {
          isShowLoader ? <Loader /> : ''
        }
      </Router>
    ) :
      (
        <Router>
          <div className={(sidebarCollapse ? "sidebar-collapse " : "") + "wrapper"}>
            <Header sidebarCollapse={sidebarCollapse} setSidebarCollapse={this.setSidebarCollapse} />
            <SideBar sidebarCollapse={sidebarCollapse} />
            <Switch>
              {
                PRIVATE_ROUTES.map((route, index) => <PrivateRouteAction key={index} {...route} />)
              }
            </Switch>
            <div id="sidebar-overlay" onClick={() => this.setSidebarCollapse(!sidebarCollapse)}></div>
          </div>
          {
            isShowLoader ? <Loader /> : ''
          }
        </Router>
      )
  }
}

const mapStateToProps = state => {
  return {
    isShowLoader: state.subStore.isShowLoader,
    jwtToken: state.account.jwtToken
  }
}

export default connect(mapStateToProps)(App);
