<template>
  <ShowNotification @clickShowNotification="clickShowNotification" :selectedNotification="selectedNotification"/>
  <Menu as="div" id="NotificationMenu" v-on:click="getNotifications(10)" class="relative ml-3">
    <div>
      <MenuButton class="relative rounded-full bg-slate-900 p-1 text-slate-300 hover:text-white focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-slate-800 focus:outline-hidden">
        <span class="absolute -inset-1.5" />
        <span class="sr-only">View notifications</span>
        <div v-if="iconState === true" >
          <BellSnoozeIcon class="size-6" aria-hidden="true" />
        </div>
        <div v-else>
          <BellIcon class="size-6" aria-hidden="true" />
        </div>
      </MenuButton>
    </div>
    <transition enter-active-class="transition ease-out duration-100" enter-from-class="transform opacity-0 scale-95" enter-to-class="transform opacity-100 scale-100" leave-active-class="transition ease-in duration-75" leave-from-class="transform opacity-100 scale-100" leave-to-class="transform opacity-0 scale-95">
      <MenuItems class="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-slate-800 py-1 shadow-lg ring-1 ring-black/5 focus:outline-hidden">
        <MenuItem v-for="notification in unviewedNotifications" :key="notification.id" v-slot="{ active }">
          <a href="#" v-on:click="setModalNotification(notification)" :class="[active ? 'bg-slate-700 outline-hidden ' : '', 'truncate block px-4 py-2 text-sm text-slate-300'] ">
            {{ notification.title }}
          </a>
        </MenuItem>
        <MenuItem v-slot="{ active }">
          <a href="#" v-on:click="showAllNotifications" :class="[active ? 'bg-slate-700 outline-hidden' : '', 'block px-4 py-2 text-sm text-slate-300']">
            {{ $t('notification.show_all') }}
          </a>
        </MenuItem>
      </MenuItems>
    </transition>
  </Menu>
</template>

<script>
  import { BellIcon, BellSnoozeIcon } from '@heroicons/vue/24/outline';
  import { Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/vue';
  import NotificationService from '../services/notification.service';

  export default {
    name: 'NavBarNotification',
    components: {
      BellIcon,
      BellSnoozeIcon,
      Menu,
      MenuButton,
      MenuItem,
      MenuItems,
    },
    mounted() {
      this.getNotifications();
    },
    computed: {
      unviewedNotifications() {
        return this.notifications.filter(notification => notification.viewed === false).sort((a, b) => b.id - a.id).slice(0, 10);
      },
      iconState() {
        return this.$store.state.notification.unviewed
      }
    },
    data() {
      return {
        notifications: [],
        selectedNotification: null
      }
    },
    props: {
      showNotification: {
        type: Boolean,
        default: false
      }
    },
    methods: {
      showAllNotifications() {
        this.$router.push('/user/notifications');
      },
      setModalNotification(notification) {
        this.selectedNotification = notification
      },
      clickShowNotification(data) {
        const indexToRemove = this.unviewedNotifications.findIndex(obj => obj.id === this.selectedNotification.id);
        if (indexToRemove !== -1) {
          this.unviewedNotifications.splice(indexToRemove, 1);
        }
        if (data === false) {
          this.selectedNotification = null
        }
      },
      async getNotifications() {
        await NotificationService.get_notifications().then(
          (response) => {
            this.notifications = response.data.notifications;
          },
          (error) => {
            this.message =
              (error.response &&
                error.response.data &&
                error.response.data.error) ||
              error.message ||
              error.toString();
            this.successful = false;
            this.loading = false;
          }
        );
      },
    }
  };
</script>