import { createApp } from 'vue';
import Application from '../Application.vue';
import i18n from "../javascript/i18n.js";
import router from "../router/index.js";
import store from "../store/index.js";
import { createNotivue } from 'notivue';
import ShowNotification from '../components/user/notifications/ShowNotification.vue';

document.addEventListener('DOMContentLoaded', () => {
  const rootApp = createApp(Application)

  // Configure notification
  const notivue = createNotivue({
    position: 'bottom-right',
    limit: 7,
    enqueue: true,
    avoidDuplicates: true,
    notifications: {
      global: {
        duration: 10000
      }
    }
  })

  rootApp.use(i18n)
  rootApp.use(router)
  rootApp.use(store)
  rootApp.use(notivue)
  rootApp.component('ShowNotification', ShowNotification)

  rootApp.mount('#app')

  // Set current and default theme
  let htmlElm = document.querySelector("html")
  if (!("theme" in localStorage)) {
    localStorage.theme = "light"
    htmlElm.classList.add("light")
  } else {
    htmlElm.classList.add(localStorage.getItem("theme"))
  }
})

export const API_URL = import.meta.env.VITE_API_URL
export const BROKER_WS = import.meta.env.VITE_BROKER_WS
export const BROKER_VHOST = import.meta.env.VITE_BROKER_VHOST
export const BROKER_USERNAME = import.meta.env.VITE_BROKER_USERNAME
export const BROKER_PASSWORD = import.meta.env.VITE_BROKER_PASSWORD