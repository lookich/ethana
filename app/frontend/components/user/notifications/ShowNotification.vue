<template>
  <div v-if="selectedNotification">
    <!-- <button v-on:click="showNotification = true"></button> -->
    <TransitionRoot as="template" :show="showNotification">
      <Dialog class="relative z-10" v-on:close="setShowNotification(false)">
        <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0" enter-to="opacity-100" leave="ease-in duration-200" leave-from="opacity-100" leave-to="opacity-0">
          <div class="fixed inset-0 bg-slate-500/75 transition-opacity" />
        </TransitionChild>

        <div class="fixed inset-0 z-10 w-full overflow-y-auto">
          <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
            <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95" enter-to="opacity-100 translate-y-0 sm:scale-100" leave="ease-in duration-200" leave-from="opacity-100 translate-y-0 sm:scale-100" leave-to="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95">
              <DialogPanel class="relative transform overflow-hidden rounded-lg bg-slate-200 dark:bg-slate-900 text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
                <div class="bg-slate-200 dark:bg-slate-900 px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                  <div class="sm:flex sm:items-start">
                    <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                      <DialogTitle as="h2" class="text-base text-slate-950 dark:text-slate-300"> {{ selectedNotification.title }}</DialogTitle>
                      <div class="items-center justify-center">
                        <p class="text-sm text-slate-500 dark:text-slate-200"> {{ selectedNotification.created_at }} </p>
                      </div>
                      <div class="mt-2">
                        <p class="text-wrap text-sm text-slate-950 dark:text-slate-300"> {{ selectedNotification.body }} </p>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
                  <button type="button" class="inline-flex w-full justify-center rounded-md bg-slate-600 px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-slate-500 dark:hover:bg-slate-500 sm:ml-3 sm:w-auto" v-on:click="setShowNotification(false)">{{ $t('notification.close') }}</button>
                </div>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
  </div>
</template>

<script>
  import { Dialog, DialogPanel, DialogTitle, TransitionChild, TransitionRoot } from '@headlessui/vue'
  import { ExclamationTriangleIcon } from '@heroicons/vue/24/outline'
  import NotificationService from '../../../services/notification.service';

  export default {
    name: 'ShowNotification',
    components: {
      Dialog,
      DialogPanel,
      DialogTitle,
      TransitionChild,
      TransitionRoot,
      ExclamationTriangleIcon
    },
    props: {
      selectedNotification: {
        type: Object,
        default: null
      }
    },
    watch: {
      selectedNotification(newVal, oldVal) {
        if (newVal !== null) {
          this.showNotification = true
        }
      }
    },
    data() {
      return {
        showNotification: true
      }
    },
    methods: {
      setViewdNotification(notification) {
        notification.viewed = true
        NotificationService.update_notification(notification).then(
          (response) => {
            if (response.data === false) {
              this.$store.dispatch("notification/setUnviewed", false)
            } else if (response.data === true) {
              this.$store.dispatch("notification/setUnviewed", true)
            };
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
      setShowNotification(value) {
        this.showNotification = value;
        this.$emit('clickShowNotification', this.showNotification);
        this.setViewdNotification(this.selectedNotification)
      }
    },
  }

</script>
