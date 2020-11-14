import React from "react";
import { Pagination } from "semantic-ui-react";
import {connect} from "react-redux";
import {SetCurrentFlight} from "../../actions"


class FlightPagi extends React.Component {
    handlePageChange = (evt, data) => {
        this.props.setPage(data.activePage);
    }
    render() {
        let {totalPage} = this.props.flight;
        return totalPage > 1 ? (
            <Pagination
                boundaryRange={0}
                defaultActivePage={1}
                ellipsisItem={null}
                firstItem={null}
                lastItem={null}
                siblingRange={1}
                totalPages={totalPage}
                onPageChange={this.handlePageChange}
            />
        ) : <span></span>
    }
}

const mapStateToProps = state => {
    return {
        flight: state.Flight
    }
}

const mapDispatchToProps = dispatch => {
    return {
        setPage(pageNumber) {
            dispatch(SetCurrentFlight(pageNumber))
        }
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(FlightPagi);