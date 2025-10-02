import AuthService from '../../services/auth.service';
import router from '../../router/index.js';

const initialState = { loggedIn: false, user: null, token: null };

export let authentication = {
  namespaced: true,
  state: initialState,
  actions: {
    async sign_in({ commit }, user) {
      const request = AuthService.sign_in(user)
      const response = await authentication.getResponse(request)
      return request.then(
        () => {
          commit('signinSuccess', response.data.user);
          commit('setToken', response.data.user.token);
          return Promise.resolve(response.data.user);
        },
        error => {
          commit('signinFailure', error.response.status);
          return Promise.reject(error);
        }
      );
    },
    async sign_out({ commit }) {
      const request = AuthService.sign_out();
      const response = await authentication.getResponse(request)
      return request.then(
        () => {
          commit('signout');
      router.push("/user/sign_in");
        },
        error => {
          return Promise.reject(error);
        }
      );
    },
    async sign_up({ commit, dispatch }, user, token) {
      const request = AuthService.sign_up(user)
      const response = await authentication.getResponse(request)
      return request.then(
        () => {
          const token = response.data.user.token
          commit('setToken', token);
          return Promise.resolve(response.data.user);
        },
        error => {
          commit('signupFailure');
          return Promise.reject(error);
        }
      );
    },
    reset_auth({commit}) {
      commit('signout');
    },
    signinAfterConfirm({ commit }, { user }) {
      commit('signinSuccess', user);
      commit('setToken', user.token);
    },
    async confirm_email({ commit, dispatch }, confirmation_token) {
      const request = AuthService.confirm_email(confirmation_token)
      const response = await authentication.getResponse(request)
      const user = response.data.user
      return request.then(
        () => {
          dispatch('signinAfterConfirm', { user });
          router.push("/home")
        },
        error => {
          return Promise.reject(error);
        }
      );
    },
  },
  mutations: {
    signinSuccess(state, user) {
      state.loggedIn = true;
      state.user = user;
    },
    signinFailure(state, response_status) {
      state.loggedIn = false;
      state.user = null;
      if (response_status === 401) {
        state.token = null;
      }
    },
    signout(state) {
      state.loggedIn = false;
      state.user = null;
      state.token = null;
    },
    signupSuccess(state) {
      state.loggedIn = false;
    },
    signupFailure(state) {
      state.loggedIn = false;
    },
    setToken(state, token) {
      state.token = token;
    }
  },
  getResponse(request) {
    return Promise.resolve(request)
  },
};

