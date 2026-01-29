import http from 'k6/http';
import { check, sleep } from 'k6';
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/2.4.0/dist/bundle.js";


export const options = {
    stages: [
        { duration: '10s', target: 10 },
        { duration: '20s', target: 50 },
        { duration: '30s', target: 100 },
        { duration: '60s', target: 100 },
        { duration: '20s', target: 0 },
    ],
    thresholds: {
        http_req_failed: ['rate<0.05'],
        http_req_duration: ['p(95)<7000'],
    },
};

const URL = 'http://141.227.165.115/api/genres';

export default function () {
    const res = http.get(URL);

    check(res, {
        'status is 200': r => r.status === 200,
        'response is JSON': r => r.headers['Content-Type']?.includes('application/json'),
    });

    sleep(1);
}

// Generate HTML report
export function handleSummary(data) {
    return {
        [`GenresGetRampUpReport-${__ENV.BUILD_NUMBER}.html`]: htmlReport(data),
    };
}