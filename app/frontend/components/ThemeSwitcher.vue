<template>
  <div class="block px-4 py-2 text-base text-slate-300">
    <label class="theme-switch">
      <input type="checkbox" v-model="this.theme_checkbox" @click="toggleThemeMode">
      <div class="theme-slider round"></div>
    </label>
    <div v-if="theme == 'dark'">
      {{ $t('theme') }} {{ $t('themes.dark') }}
    </div>
    <div v-else-if="theme == 'light'">
      {{ $t('theme') }} {{ $t('themes.light') }}
    </div>
  </div>
</template>

<script>
  export default {
    data(){
      return {
        theme: '',
        theme_checkbox: false
      }
    },
    mounted() {
      this.toggleThemeMode(localStorage.theme);
    },
    methods: {
      toggleThemeMode(theme, evt) {
        let htmlElm = document.querySelector("html");
        const setLight = () => {
          htmlElm.classList.remove("dark");
          htmlElm.classList.add("light");
          localStorage.theme = "light";
          this.theme = "light";
        };
        const setDark = () => {
          htmlElm.classList.remove("light");
          htmlElm.classList.add("dark");
          localStorage.theme = "dark";
          this.theme = "dark";
          this.theme_checkbox = !this.theme_checkbox
        };

        if (typeof theme === "string") {
          if (theme == "dark") setDark();
          else setLight();
        } else {
          if (localStorage.theme === "dark") setLight();
          else setDark();
        }
      },
    },
  }
</script>