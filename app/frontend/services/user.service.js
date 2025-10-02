import axios from 'axios';
import authHeader from '../helpers/auth-header';
import { API_URL } from '../entrypoints/application';


class UserService {
  getPublicContent() {
    return axios.get(API_URL + '/api/v1/home', { headers: authHeader() });
  }

  getUserBoard() {
    return axios.get(API_URL + '/api/v1/user/current_user', { headers: authHeader() });
  }
}

export default new UserService();
