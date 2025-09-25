<template>
  <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <h2 class="mt-10 text-center text-2xl/9 font-bold tracking-tight text-slate-950">{{ $t('auth.password_recover') }}</h2>
    </div>

    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
      <Form @submit="resetPassword" :validation-schema="schema" class="space-y-6" action="#" method="POST">
        <div class="sm:col-span-4">
          <div class="flex items-center justify-between">
            <label for="password" class="block text-sm/6 font-medium text-slate-950">{{ $t('auth.password') }}</label>
          </div>
          <div class="mt-2">
            <Field type="password" name="password" id="password" class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-slate-900 outline-1 -outline-offset-1 outline-slate-300 placeholder:text-slate-400 focus:outline-2 focus:-outline-offset-2 focus:outline-slate-600 sm:text-sm/6" />
          </div>
          <ErrorMessage name="password" class="error-feedback" />
        </div>
        <div class="sm:col-span-4">
          <div class="flex items-center justify-between">
            <label for="password_confirmation" class="block text-sm/6 font-medium text-slate-950">{{ $t('auth.password_confirmation') }}</label>
          </div>
          <div class="mt-2">
            <Field type="password" name="password_confirmation" id="password_confirmation" class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-slate-900 outline-1 -outline-offset-1 outline-slate-300 placeholder:text-slate-400 focus:outline-2 focus:-outline-offset-2 focus:outline-slate-600 sm:text-sm/6" />
          </div>
          <ErrorMessage name="password_confirmation" class="error-feedback" />
        </div>

        <div>
          <button type="submit" :disabled="loading" class="flex w-full justify-center rounded-md bg-slate-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-xs hover:bg-slate-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-slate-600">
            <span
              v-show="loading"
              class="spinner-border spinner-border-sm"
            ></span>
            <span>
              {{ $t('auth.button.password_recover') }}
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
  import AuthService from '../../services/auth.service';
  import * as yup from "yup";
  export default {
    name: 'PasswordReset',
    components: {
      Form,
      Field,
      ErrorMessage,
    },
    data() {
      const schema = yup.object().shape({
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
        loading: false,
        message: "",
        schema,
      };
    },
    methods: {
      resetPassword(user) {
        const request = AuthService.reset_password(user, this.$route.query["reset_password_token"])
        const response = Promise.resolve(request)
        return request.then(
          () => {
            this.$router.push("/user/sign_in");
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