import { createApp } from 'vue'
import Application from '../Application.vue'

document.addEventListener('DOMContentLoaded', () => {
  const rootApp = createApp(Application)
  rootApp.mount('#app')
})
