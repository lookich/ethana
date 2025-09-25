import axios from 'axios';
import authHeader from '../helpers/auth-header';
import browserDetect from '../helpers/browser_detect';
import { API_URL } from '../entrypoints/application';

const browserData = browserDetect()

class AuthService {
  sign_in(user) {
    return axios
      .post(API_URL + '/api/v1/user/sign_in',
        {
          user: {
            email: user.email,
            password: user.password
          },
          browser: browserData,
          os: browserData['os']
        },
        {
          headers: authHeader()
        })
  }

  sign_out() {
    return axios.post(API_URL + '/api/v1/user/sign_out', {}, { headers: authHeader() })
  }

  sign_up(user) {
    return axios
      .post(API_URL + '/api/v1/user/sign_up',
        {
          user: {
            email: user.email,
            password: user.password,
            password_confirmation: user.password_confirmation
          },
          browser: browserData,
          os: browserData['os']
        },
        {
          headers: authHeader()
        })
  }

  confirm_email(confirmation_token) {
    return axios
      .post(API_URL + '/api/v1/user/confirm_email',
        {
          user: {
            confirmation_token: confirmation_token
          }
        },
        {
          headers: authHeader()
        })
      }

  reset_password_instruction(email) {
    return axios
      .post(API_URL + '/api/v1/user/reset_password_instructions',
        {
          user: {
            email: email
          }
        },
        {
          headers: authHeader()
        })
  }

  reset_password(user, reset_password_token='') {
    return axios
      .post(API_URL + '/api/v1/user/reset_password',
        {
          user: {
            password: user.password,
            password_confirmation: user.password_confirmation,
            reset_password_token: reset_password_token
          }
        },
        {
          headers: authHeader()
        })
  }
}

export default new AuthService();
