import { createStore } from 'vuex';
import createPersistedState from 'vuex-persistedstate';
import { authentication } from './modules/auth';
import { notification } from './modules/notification';

const store = createStore({
  modules: {
    authentication,
    notification
  },
  plugins: [createPersistedState()],
});

export default store;
