import axios from 'axios';
import {API_URL} from '../constants/env';

export default function ApiCaller(endpoint, method = 'get', data = null, headers = null) {
    const apiUrl = API_URL.endsWith("/") ? API_URL.slice(0, -1) : API_URL;
    return axios({
        method: method,
        url: `${apiUrl}/${endpoint}`,
        data: data,
        headers: headers
    });
}
