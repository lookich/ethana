import store from '../store';
import browserDetect from './browser_detect';
import { sha256, sha224 } from 'js-sha256';

const browserData = browserDetect()
const message = browserData['os'] + browserData['name'] + browserData['version']
const JWT_AUD = sha256.hex(message)

export default function authHeader() {
  if (store.state.authentication.token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': `Bearer ${store.state.authentication.token}`,
      'JWT_AUD': JWT_AUD
    };
  } else {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'JWT_AUD': JWT_AUD
    };
  }
}