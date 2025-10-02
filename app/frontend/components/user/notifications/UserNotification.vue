<template>
  <Notivue v-slot="item">
    <Notification :item="item" :theme="notificationTheme" />
  </Notivue>
</template>

<script>
  import { Notivue, Notification, push, lightTheme, darkTheme } from 'notivue';
  import WebSocketService from '../../../services/websocket.service';
  import { useSound } from '@vueuse/sound';
  import notificationSfx from '../../../../assets/sounds/notification.mp3';

  export default {
    name: 'UserNotification',
    components: {
      Notivue: Notivue,
      Notification: Notification,
    },
    setup() {
      const { play } = useSound(notificationSfx);
      return { play };
    },
    data() {
      return {
        stompClient: null,
        subscription: null,
      };
    },
    props: {
      currentUser: {
        type: Object,
        default: null
      },
    },
    computed: {
      notificationTheme() {
        return localStorage.theme === 'dark' ? darkTheme : lightTheme
      },
    },
    mounted() {
      if (this.currentUser !== null) {
        this.subscribeQueue("/queue/notification-" + this.currentUser.email);
      }
    },
    methods: {
      subscribeQueue(queue_name) {
        this.stompClient = WebSocketService.client()

        this.stompClient.onConnect = (frame) => {
          this.subscription = this.stompClient.subscribe(queue_name, (message) => {
            const new_notification = JSON.parse(message.body)
            if (new_notification !== undefined) {
              this.play();
            }
            const notification_date = Date.parse(new_notification.created_at)
            new_notification.created_at = notification_date
            this.$store.dispatch("notification/setUnviewed", true)
            switch (new_notification.notification_type) {
              case 'info':
                return push.info({
                  title: new_notification.title
                })
                case 'success':
                  return push.success({
                    title: new_notification.title
                  })
                case 'warning':
                  return push.warning({
                    title: new_notification.title
                  })
                case 'error':
                  return push.error({
                    title: new_notification.title
                  })
                case 'promise':
                  return push.promise({
                    title: new_notification.title
                  })
                case 'promise-resolve':
                  return push.promise-resolve({
                    title: new_notification.title
                  })
                case 'promise-reject':
                  return push.promise-reject({
                    title: new_notification.title
                  })
              }
          });
        };

        this.stompClient.onStompError = (frame) => {
          console.error('Broker reported error:', frame.headers['message']);
          console.error('Additional details:', frame.body);
        };

        this.stompClient.activate();
      },
      unsubscribeQueue() {
        if (this.subscription) {
          this.subscription.unsubscribe();
          this.subscription = null;
        }
      }
    },
    beforeUnmount() {
      this.unsubscribeQueue();
      if (this.stompClient) {
        this.stompClient.deactivate();
      }
    },
  };
</script>
