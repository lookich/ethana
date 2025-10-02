import { createWebHistory, createRouter } from 'vue-router';
import store from '../store';
import Home from "../components/Home.vue";
import Sign_in from '../components/user/Sign_in.vue';
import Sign_up from '../components/user/Sign_up.vue';
import ConfirmationSent from '../components/user/ConfirmationSent.vue';
import EmailConfirmation from '../components/user/EmailConfirmation.vue';
import PasswordRecover from '../components/user/PasswordRecover.vue';
import PasswordReset from '../components/user/PasswordReset.vue';
import ShowAllNotifications from '../components/user/notifications/ShowAllNotifications.vue';
import axios from 'axios';

const routes = [
  {
    path: "/",
    name: "home",
    component: Home,
  },
  {
    path: "/home",
    name: "/home",
    component: Home,
  },
  {
    path: "/user/sign_in",
    name: "sign_in",
    component: Sign_in,
  },
  {
    path: "/user/sign_up",
    component: Sign_up,
    name: "sign_up",
  },
  {
    path: "/user/confirmation_sent",
    component: ConfirmationSent,
    name: "confirmation_sent",
  },
  {
    path: "/user/confirm_email",
    component: EmailConfirmation,
    name: "confirm_email",
  },
  {
    path: "/user/recover_password",
    name: "recover_password",
    component: PasswordRecover,
  },
  {
    path: "/user/reset_password",
    name: "reset_password",
    component: PasswordReset,
  },
  {
    path: "/user/notifications",
    name: "notifications",
    component: ShowAllNotifications,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  // redirect to login page if not logged in and trying to access a restricted page
  const publicPages = [
    '/user/sign_in',
    '/user/sign_up',
    '/user/recover_password',
    '/user/reset_password',
    '/user/confirm_email',
    '/user/confirmation_sent',
    '/',
    '/home'
  ];
  const authRequired = !publicPages.includes(to.path);
  const loggedIn = store.state.authentication.loggedIn

  axios.interceptors.response.use(function (response) {
    return response;
  }, function (error) {
    let originalRequest = error.config
    if (error.response && error.response.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true
      store.dispatch('authentication/reset_auth')
      router.push("/user/sign_in")
      return axios(originalRequest);
    }
    return Promise.reject(error);
  });

  if (authRequired && !loggedIn) {
    next('/user/sign_in');
  } else if (loggedIn && to.path === '/sign_in') {
    router.push("/home")
  } else {
    next();
  }
})

export default router;
