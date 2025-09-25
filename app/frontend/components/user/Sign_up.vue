<template>
  <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <h2 class="h2-main">{{ $t('auth.signup_to.account') }}</h2>
    </div>

    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
      <Form @submit="handleSignup" :validation-schema="schema" class="space-y-6" action="#" method="POST">
        <div v-if="!successful">
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
            </div>
            <div class="mt-2">
              <Field type="password" name="password" id="password" class="field-main" />
            </div>
            <ErrorMessage name="password" class="alert-main" />
          </div>
          <div class="sm:col-span-4">
            <div class="flex items-center justify-between">
              <label for="password_confirmation" class="label-main">{{ $t('auth.password_confirmation') }}</label>
            </div>
            <div class="mt-2">
              <Field type="password" name="password_confirmation" id="password_confirmation" class="field-main" />
            </div>
            <ErrorMessage name="password_confirmation" class="alert-main" />
          </div>

          <div>
            <button type="submit" :disabled="loading" class="flex w-full justify-center rounded-md bg-slate-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-xs hover:bg-slate-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-slate-600">
              <span
                v-show="loading"
                class="spinner-border spinner-border-sm"
              ></span>
              <span>
                {{ $t('auth.button.signup') }}
              </span>
            </button>
            <div class="form-group">
              <div v-if="message" class="alert-main" role="alert">
                {{ message }}
              </div>
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
    name: "Sign_up",
    components: {
      Form,
      Field,
      ErrorMessage,
    },
    data() {
      const schema = yup.object().shape({
        email: yup
          .string()
          .required(this.$i18n.t('auth.email_required'))
          .email(this.$i18n.t('auth.email_invalid'))
          .max(50, this.$i18n.t('auth.email_length_max')),
        password: yup
          .string()
          .required(this.$i18n.t('auth.password_required'))
          .min(6, this.$i18n.t('auth.password_length_min'))
          .max(40, this.$i18n.t('auth.password_length_max')),
        password_confirmation: yup
          .string()
          .oneOf([yup.ref('password'), null], this.$i18n.t('auth.password_confirmation_not_matched'))
      });

      return {
        successful: false,
        loading: false,
        message: "",
        schema,
      };
    },
    mounted() {
      if (this.$store.state.authentication.loggedIn) {
        this.$router.push("/");
      }
    },
    methods: {
      handleSignup(user) {
        this.message = "";
        this.successful = false;
        this.loading = true;

        this.$store.dispatch("authentication/sign_up", user).then(
          (data) => {
            this.message = data.message;
            this.successful = true;
            this.loading = false;
            this.$router.push("/user/confirmation_sent");
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
    },
  };
</script>
