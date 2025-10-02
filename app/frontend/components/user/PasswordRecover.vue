<template>
  <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <h2 class="h2-main">{{ $t('auth.password_recover') }}</h2>
    </div>

    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
      <Form @submit="recoverPassword" :validation-schema="schema" class="space-y-6" action="#" method="POST">
        <div class="sm:col-span-4">
          <label for="email" class="label-main">{{ $t('auth.email') }}</label>
          <div class="mt-2">
            <Field type="email" name="email" id="email" autocomplete="email" class="field-main" />
          </div>
          <ErrorMessage name="email" class="alert-main" />
        </div>

        <div>
          <button type="submit" :disabled="loading" class="btn-main">
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
    name: 'PasswordRecover',
    components: {
      Form,
      Field,
      ErrorMessage,
    },
    data() {
      const schema = yup.object().shape({
        email: yup.string().required(this.$i18n.t('auth.email_required')),
      });

      return {
        loading: false,
        message: "",
        schema,
      };
    },
    methods: {
      recoverPassword(user) {
        const request = AuthService.reset_password_instruction(user.email)
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