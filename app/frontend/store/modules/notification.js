const initialState = { unviewed: false };

export let notification = {
  namespaced: true,
  state: initialState,
  actions: {
    setUnviewed({ commit }, value) {
      commit('setUnviewed', value);
    },
  },
  mutations: {
    setUnviewed(state, value) {
      state.unviewed = value;
    },
  },
};

