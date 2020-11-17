import React from "react";
import "./style.scss";

class TicketClass extends React.Component {
    constructor(props) {
        super(props);
        this.inputRef = React.createRef();
    }
    handleSelect = evt => {
        if(this.inputRef.current) {
            this.inputRef.current.click();
        }
    }
    handleChangeChecked = evt => {
        this.props.handleShow(evt.target.checked, this.props.type)
    }
    render() {
        let {type, isShow} = this.props;
        let classN = type === 1 ? "eco" : type === 2 ? "pre" : "bus";
        let label = type === 1 ? "Ars economy" : type === 2 ? "Ars premium" : "Ars business";
        return (
            <div className={`${classN} ticket-class`} onClick={this.handleSelect}>
                <p>{label}</p>
                <div className="control">
                    <input type="checkbox" ref={this.inputRef} checked={isShow} 
                    onChange={this.handleChangeChecked}/>
                    <span className="control-indicator"></span>
                </div>
            </div>
        )
    }
}

export default TicketClass;