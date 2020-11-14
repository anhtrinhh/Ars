import { MapPinPointIcon } from "../../icons";
import {Dropdown} from "semantic-ui-react";

export default function ToField({data, setData}){
    const handleChange = (evt, data) => {
        setData(data.value, "TO");
    }
    return (
        <div className="tab-search__form-field--1">
            <label>To</label>
            <Dropdown
                placeholder='Select destination'
                fluid
                search
                selection
                icon={null}
                options={data}
                className="tab-search__dropdown"
                onChange={handleChange}
            />
            <span className="tab-search__input-icon">
                <MapPinPointIcon />
            </span>
        </div>
    )
}