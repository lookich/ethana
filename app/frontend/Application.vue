<template>
  <div>
    <NavBar />
    <UserNotification v-if="currentUser" :currentUser="currentUser" />
    <router-view></router-view>
  </div>
</template>

<script>
  import NavBar from './components/NavBar.vue';
  import UserNotification from './components/user/notifications/UserNotification.vue';

  export default {
    components: {
      NavBar: NavBar,
      UserNotification: UserNotification,
    },
    computed: {
      currentUser() {
        return this.$store.state.authentication.user;
      }
    }
  };
</script>
