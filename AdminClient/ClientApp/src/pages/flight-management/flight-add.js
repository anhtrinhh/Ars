import React from "react";
import BasicInfo from "../../components/flight/flight-basic-info";

class FlightAdd extends React.Component {
    render() {
        return (
            <div className="content-wrapper">
                <div className="content-header">
                    <div className="container-fluid">
                        <div className="row mb-2">
                            <div className="col-12">
                                <h3>Add Flight</h3>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="content">
                    <div className="container-fluid">
                        <h4>Basic information</h4>
                        <BasicInfo />
                    </div>
                </div>
            </div>
        )
    }
}

export default FlightAdd;