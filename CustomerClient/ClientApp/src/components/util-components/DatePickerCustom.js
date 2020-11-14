import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";
import "./style.scss";
import { Icon } from "semantic-ui-react";

export default function DatePickerCustom({ placeholderText, onChange, onFocus, selected, maxDate, minDate }) {
    function customDatePickerHeader({ date, changeYear, changeMonth, decreaseMonth, increaseMonth, prevMonthButtonDisabled, nextMonthButtonDisabled }) {
        const years = [];
        let d = new Date();
        d.setFullYear(d.getFullYear() - 18);
        let mind = minDate || new Date("1940-01-01");
        let md = maxDate || d;
        for (let i = md.getFullYear(); i >= mind.getFullYear(); i--) {
            years.push(i);
        }
        const months = [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
        ];
        return (
            <div className="datepicker-custom-header">
                <button onClick={decreaseMonth} disabled={prevMonthButtonDisabled}>
                    <Icon name="arrow left" />
                </button>
                <select
                    value={date.getFullYear()}
                    onChange={({ target: { value } }) => changeYear(value)}
                >
                    {years.map(option => (
                        <option key={option} value={option}>
                            {option}
                        </option>
                    ))}
                </select>

                <select
                    value={months[date.getMonth()]}
                    onChange={({ target: { value } }) =>
                        changeMonth(months.indexOf(value))
                    }
                >
                    {months.map(option => (
                        <option key={option} value={option}>
                            {option}
                        </option>
                    ))}
                </select>

                <button onClick={increaseMonth} disabled={nextMonthButtonDisabled}>
                    <Icon name="arrow right" />
                </button>
            </div>
        )
    }
    return (
        <DatePicker
            placeholderText={placeholderText}
            onChange={onChange}
            onFocus={onFocus}
            selected={selected}
            renderCustomHeader={customDatePickerHeader}
            maxDate={maxDate}
            minDate={minDate}
        />
    )
}
