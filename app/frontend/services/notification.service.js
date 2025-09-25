import axios from 'axios';
import authHeader from '../helpers/auth-header';
import { API_URL } from '../entrypoints/application';

class NotificationService {
  get_notifications(notification_numbers) {
    return axios
      .get(API_URL + '/api/v1/user/notifications',
        {
          headers: authHeader(),
          params: { notification_numbers: notification_numbers }
        })
  }
  update_notification(notification) {
    return axios
      .put(API_URL + `/api/v1/user/notifications/${notification.id}`,
        {
         notification: notification
        },
        {
          headers: authHeader(),
        })
  }
  delete_notification(id) {
    return axios
      .delete(API_URL + `/api/v1/user/notifications/${id}`,
        {
          headers: authHeader(),
        })
  }
}

export default new NotificationService();
