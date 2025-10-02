<template>
</template>

<script>
export default {
  name: 'EmailConfirmation',
  mounted() {
    this.confirmEmail(this.$route.query);
  },
  methods: {
    confirmEmail(params) {
      this.$store.dispatch("authentication/confirm_email", params['confirmation_token']).then(
        () => {
          this.$router.push("/home");
        },
        (error) => {
          this.message =
            (error.response &&
              error.response.data &&
              error.response.data.error) ||
            error.message ||
            error.toString();
        }
      );
    }
  }
}
</script>