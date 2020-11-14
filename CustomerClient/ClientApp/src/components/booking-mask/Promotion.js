import {Checkbox} from "semantic-ui-react";
import {useRef} from "react";

export default function Promotion() {
    let hideRef = useRef(null);
    const handleChange = (evt, {checked}) => {
        if(checked) {
            hideRef.current.classList.remove("hide");
        } else {
            hideRef.current.classList.add("hide");
        }
    }
    return (
        <div className="tab-search__form-row">
            <div className="tab-search__form-field--3">
                <Checkbox label="Add promo code" onChange={handleChange}/>
            </div>
            <div className="tab-search__form-field--4 hide" ref={hideRef}>
                <input type="text" placeholder="Promo code" name="promo-code"/>
            </div>
        </div>
    )
}