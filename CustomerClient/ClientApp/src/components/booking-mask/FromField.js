import {Dropdown} from "semantic-ui-react";
import { MapPinPointIcon } from "../../icons";

export default function FromField({data, setData }){
    const handleChange = (evt, data) => {
        setData(data.value, "FROM");
    }
    return (
        <div className="tab-search__form-field--1">
            <label>From</label>
            <Dropdown
                placeholder='Select departure'
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