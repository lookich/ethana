import { BROKER_WS } from '../entrypoints/application';
import { BROKER_VHOST } from '../entrypoints/application';
import { BROKER_USERNAME } from '../entrypoints/application';
import { BROKER_PASSWORD } from '../entrypoints/application';
import { Client } from '@stomp/stompjs';

class WebSocketService {
  client() {
    return new Client({
      brokerURL: BROKER_WS,
      connectHeaders: {
        login: BROKER_USERNAME,
        passcode: BROKER_PASSWORD,
        host: BROKER_VHOST,
      },
      reconnectDelay: 5000,
      heartbeatIncoming: 4000,
      heartbeatOutgoing: 4000,
    });
  }
}

export default new WebSocketService();