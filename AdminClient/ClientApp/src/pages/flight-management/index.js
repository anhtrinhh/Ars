import React from "react";
import { Button } from "semantic-ui-react"
import FormSearch from "../../components/flight/form-search";
import { Link } from "react-router-dom";

class FlightManagement extends React.Component {
    render() {
        return (
            <div className="content-wrapper">
                <div className="content-header">
                    <div className="container-fluid">
                        <div className="row mb-2">
                            <div className="col-12">
                                <h3>Flight Management</h3>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="content">
                    <div className="container-fluid">
                        <h4>Search flight</h4>
                        <FormSearch {...this.props} />
                        <h4>Add flight</h4>
                        <div className="row">
                            <div className="col-12">
                                <Link to={this.props.location.pathname + "/add/1"}>
                                    <Button>Add flight</Button>
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}

export default FlightManagement;