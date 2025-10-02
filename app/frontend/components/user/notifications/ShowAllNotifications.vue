<template>
  <ShowNotification @clickShowNotification="clickShowNotification" :selectedNotification="selectedNotification"/>
  <div class="flex justify-center">
    <ul role="list" class="max-w-lg divide-y divide-slate-100">
      <li v-for="(notification, index) in displayedNotifications" :key="notification.id" class="flex justify-between gap-x-6 py-5">
        <div class=" min-w-0 gap-x-4">
          <div class="min-w-0">
            <div class="flex gap-x-4">

              <div v-if="notification.viewed" >
                <EnvelopeOpenIcon class="size-5" aria-hidden="true" />
              </div>
              <div v-else>
                <EnvelopeIcon class="size-5" aria-hidden="true" />
              </div>
              <a href="#" v-on:click="setModalNotification(notification)" :class="[notification.viewed ? 'ntfc-title font-normal' : 'ntfc-title font-bold']">
                {{ notification.title }}
              </a>
            </div>
            <p class="mt-1 truncate text-xs/5 text-slate-950 dark:text-slate-300">{{ notification.body }}</p>
          </div>
        </div>
        <div class="hidden shrink-0 sm:flex sm:flex-col sm:items-end">
          <button v-on:click="deleteNotification(notification, index)" class="btn-main">{{ $t('notification.delete') }}</button>
          <p class="mt-1 text-xs/5 text-slate-600 dark:text-slate-300">
            {{ $t('notification.date') }} <time :datetime="notification.created_at">{{ notification.created_at }}</time>
          </p>
        </div>
      </li>
    </ul>
  </div>
  <Pagination
    :totalPages="totalPages"
    :perPage="perPage"
    :currentPage="currentPage"
    @pagechanged="onPageChange"
  />
</template>

<script>
  import NotificationService from '../../../services/notification.service';
  import { EnvelopeIcon, EnvelopeOpenIcon } from '@heroicons/vue/24/outline';
  import Pagination from '../../Pagination.vue';

  export default {
    name: 'ShowAllNotifications',
    components: {
      Pagination,
      EnvelopeIcon,
      EnvelopeOpenIcon
    },
    created() {
      this.getNotifications()
    },
    data() {
      return {
        notifications: [],
        selectedNotification: null,
        currentPage: 1,
        perPage: 5
      };
    },
    props: {
      showNotification: {
        type: Boolean,
        default: false
      }
    },
    computed: {
      totalPages() {
        return Math.ceil(this.notifications.length/this.perPage)
      },
      displayedNotifications() {
        const startIndex = (this.currentPage - 1) * this.perPage;
        const endIndex = startIndex + this.perPage;
        return this.notifications.slice(startIndex, endIndex);
      }
    },
    methods: {
      getNotifications() {
        NotificationService.get_notifications().then(
          (response) => {
            this.notifications = response.data.notifications.sort((a, b) => b.id - a.id);
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
      deleteNotification(notification, index) {
        NotificationService.delete_notification(notification.id).then(
          (response) => {
            this.notifications.splice(index, 1);
            return response.status
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
      setModalNotification(notification) {
        this.selectedNotification = notification
      },
      clickShowNotification(data) {
        if (data === false) {
          this.selectedNotification = null
        }
      },
      onPageChange(page) {
        this.currentPage = page;
      }
    }
  };
</script>
