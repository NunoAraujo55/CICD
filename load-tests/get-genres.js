import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    stages: [
        { duration: '10s', target: 10 },    // ramp-up to 10 VUs
        { duration: '20s', target: 50 },    // ramp-up to 50 VUs
        { duration: '30s', target: 100 },   // ramp-up to 100 VUs
        { duration: '60s', target: 100 },   // hold
        { duration: '20s', target: 0 },     // ramp-down
    ],
    thresholds: {
        http_req_failed: ['rate<0.05'],
        http_req_duration: ['p(95)<200'],
    },
};

const TOKEN = 'eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJleGFtcGxlLmlvIiwic3ViIjoiNWZvUWhKc0I5ZzQzM3ZKX2h6cjEsbWFyaWFAZ21haWwuY29tIiwiZXhwIjoxNzY3NTYwNTY3LCJpYXQiOjE3Njc1MjQ1NjcsInJvbGVzIjoiTElCUkFSSUFOIn0.gxbOMp7WADe7uzjpCrJlcPmDC-Hy8fLQ8SSxPWPCHtoLV3g5sLMAL8ygvjTEDjBrpOa_4VVNYI54Z7exrrFOEscYcmdZiPVNhNTcYd9JPLpRDFWAzf7y7GG_LIdVi-aXSy4bohpIfXttNyjFN1BxIs-Aawi7tddqrpid5iXvcRVEINZNljOJGZBCfCgmSIno6JkWhRn0YMRnobE2rXGOPNO5ffc3HT3FnkB_e48i6yGQMPd3Vd8Hl-nD1LQLw6YQediPx3ip9C_1LTXk-P9wqLhrtLoVqES09ZbJRVYfW0wbKcZpqlAtgeC_6ctK5jHqAJOuqlrODsrVCTqU47OBCj39rpTCMW1U-aK9e5NBuN5-7qHOOVNhC6Ta6cKoH_QScdOKLU8LKZFF_3GkY9hwpnIcVmr0EFlejOd7rzUW71B1sgsMzFyfwGRzUTXA_8UytG28CU8k7FfSHmdzkuQReMhWmftev5fbyWz862I5IMUT2gJkP5NhURFXVn21FJfcG_CIh1-vwdHupVTIrOwJcWj8Ufzt4VnQnGyR93JPmDSPK2HmF9R56iCZ9QPzlMPh35_gsGuvquDWsBuAiQ32Gki8Z8L3oDNJXsbxXEnhWs8_ODD7K-mCvzU5qtcSWYKM3Awwp3RoSsEyRY7D12ws9xbDduzojcpspPPLD-FAi58';
const URL = 'http://141.227.165.115:8080/api/genres';

export default function () {
    const headers = {
        'Authorization': `Bearer ${TOKEN}`,
    };

    const res = http.get(URL, { headers });

    check(res, {
        'status is 200': r => r.status === 200,
        'response not empty': r => r.body && r.body.length > 0,
    });

    sleep(1);
}