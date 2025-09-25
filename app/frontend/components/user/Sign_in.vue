<template>
  <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <h2 class="h2-main">{{ $t('auth.signin_to.account') }}</h2>
    </div>

    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
      <Form @submit="handleSignin" :validation-schema="schema" class="space-y-6" action="#" method="POST">
        <div class="sm:col-span-4">
          <label for="email" class="label-main">{{ $t('auth.email') }}</label>
          <div class="mt-2">
            <Field type="email" name="email" id="email" autocomplete="email" class="field-main" />
          </div>
          <ErrorMessage name="email" class="alert-main" />
        </div>

        <div class="sm:col-span-4">
          <div class="flex items-center justify-between">
            <label for="password" class="label-main">{{ $t('auth.password') }}</label>
            <router-link to="/user/recover_password" class="link-main">
              {{ $t('auth.forgot_password') }}
            </router-link>
          </div>
          <div class="mt-2">
            <Field type="password" name="password" id="password" class="field-main" />
          </div>
          <ErrorMessage name="password" class="alert-main" role="alert" />
        </div>

        <div>
          <button type="submit" :disabled="loading" class="btn-main">
            <span
              v-show="loading"
              class="spinner-border spinner-border-sm"
            ></span>
            <span>
              {{ $t('auth.button.signin') }}
            </span>
          </button>
          <div class="form-group">
            <div v-if="message" class="alert-main" role="alert">
              {{ message }}
            </div>
          </div>
        </div>
      </Form>
    </div>
  </div>
</template>

<script>
  import { Form, Field, ErrorMessage } from "vee-validate";
  import * as yup from "yup";

  export default {
    name: "Sign_in",
    components: {
      Form,
      Field,
      ErrorMessage,
    },
    data() {
      const schema = yup.object().shape({
        email: yup.string().required(this.$i18n.t('auth.email_required')),
        password: yup.string().required(this.$i18n.t('auth.password_required')),
      });

      return {
        loading: false,
        message: "",
        schema,
      };
    },
    mounted() {
      if (this.$store.state.authentication.loggedIn) {
        this.$router.push("/home");
      }
    },
    methods: {
      handleSignin(user) {
        this.loading = true;
        this.$store.dispatch("authentication/sign_in", user).then(
          () => {
            this.$router.push("/home");
          },
          (error) => {
            this.loading = false;
            this.message =
              (error.response &&
                error.response.data &&
                error.response.data.error) ||
              error.message ||
              error.toString();
          }
        );
      },
    },
  };
</script>
