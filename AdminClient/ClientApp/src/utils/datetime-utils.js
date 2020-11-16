const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

export function getShortDateStr(date) {
    let dateStr = null;
    if (date) {
        var month = date.getMonth() + 1;
        var day = date.getDate();
        if (month < 10) {
            month = "0" + month;
        }
        if (day < 10) {
            day = "0" + day;
        }
        dateStr = `${date.getFullYear()}-${month}-${day}`;
    }
    return dateStr;
}

export function getLongDateStr(date) {
    let dateStr = null;
    if (date) {
        dateStr = `${days[date.getDay()]}, ${date.getDate()}. ${months[date.getMonth()]} ${date.getFullYear()}`;
    }
    return dateStr;
}

export function getShortTimeStr(time) {
    let timeStr = null;
    if (time) {
        let { hours, minutes } = time;
        if (hours < 10) {
            hours = "0" + hours;
        }
        if (minutes < 10) {
            minutes = "0" + minutes;
        }
        timeStr = `${hours}:${minutes}`;
    }
    return timeStr;
}

export function getMediumTimeStr(time) {
    let timeStr = null;
    if (time) {
        let { hours, minutes } = time;
        if (hours < 10) {
            hours = "0" + hours;
        }
        if (minutes < 10) {
            minutes = "0" + minutes;
        }
        timeStr = `${hours}h ${minutes}m`;
    }
    return timeStr;
}

export function subtractTime(time1, time2) {
    let hours = 0;
    let minutes = 0;
    if (time1.hours >= time2.hours) {
        hours = time1.hours - time2.hours;
    } else {
        hours = 24 - (time2.hours - time1.hours);
    }
    if (time1.minutes >= time2.minutes) {
        minutes = time1.minutes - time2.minutes;
    } else {
        minutes = 60 - (time2.minutes - time1.minutes);
        hours--;
    }
    if (hours < 10) {
        hours = "0" + hours;
    }
    if (minutes < 10) {
        minutes = "0" + minutes;
    }
    return `${hours}h ${minutes}m`;
}

export function isValidDate(dateString) {
    var regEx = /^\d{4}-\d{2}-\d{2}$/;
    if (!regEx.test(dateString)) return false;
    var d = new Date(dateString);
    var dNum = d.getTime();
    if (!dNum && dNum !== 0) return false;
    return getShortDateStr(d) === dateString;
}