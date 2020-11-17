import React from "react";
import { getShortDateStr, getMediumTimeStr } from "../../utils/datetime-utils";
import { connect } from "react-redux";
import {Link} from "react-router-dom";
import {Icon} from "semantic-ui-react";

class SummaryBasic extends React.Component {
    render() {
        let { basicInfo, flightDirection } = this.props;
        return (
            <div className="card">
                <div className="card-header bg-info text-white d-flex justify-content-between align-items-center">
                    <h5 style={{marginBottom: 0}}>Flight basic information</h5>
                    <Link to="/flight-management/add/1" style={{color: '#fff'}}>
                        <Icon name="edit" size="large"/>
                    </Link>
                </div>
                <div className="card-body">
                    <div className="row mb-2">
                        <div className="col-2">
                            <b>Flight code:</b>
                        </div>
                        <div className="col-4">
                            <p>{basicInfo.flightid}</p>
                        </div>
                        <div className="col-2">
                            <b>Flight date:</b>
                        </div>
                        <div className="col-4">
                            <p>{getShortDateStr(basicInfo.date)}</p>
                        </div>
                    </div>
                    <div className="row mb-2">
                        <div className="col-2">
                            <b>Departure:</b>
                        </div>
                        <div className="col-4">
                            <p>{flightDirection[basicInfo.fromid] ? flightDirection[basicInfo.fromid].city : ''} ({basicInfo.fromid})</p>
                        </div>
                        <div className="col-2">
                            <b>Destination:</b>
                        </div>
                        <div className="col-4">
                            <p>{flightDirection[basicInfo.toid] ? flightDirection[basicInfo.toid].city : ''} ({basicInfo.toid})</p>
                        </div>
                    </div>
                    <div className="row mb-2">
                        <div className="col-2">
                            <b>Start time:</b>
                        </div>
                        <div className="col-4">
                            <p>{getMediumTimeStr(basicInfo.time ? basicInfo.time.startTime : basicInfo.time)}</p>
                        </div>
                        <div className="col-2">
                            <b>End time:</b>
                        </div>
                        <div className="col-4">
                            <p>{getMediumTimeStr(basicInfo.time ? basicInfo.time.endTime : basicInfo.time)}</p>
                        </div>
                    </div>
                    <div className="row mb-2">
                        <div className="col-2">
                            <b>Flight note:</b>
                        </div>
                        <div className="col-8">
                            <p>{basicInfo.note}</p>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}

const mapStateToProps = state => {
    return {
        basicInfo: state.flightBasicInfo,
        flightDirection: state.flightDirection
    }
}

export default connect(mapStateToProps)(SummaryBasic);