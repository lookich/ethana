<template>
  <Disclosure as="nav" class="bg-slate-900" v-slot="{ open }">
    <div class="mx-auto max-w-7xl px-2 sm:px-6 lg:px-8">
      <div class="relative flex h-16 items-center justify-between">
        <div class="absolute inset-y-0 left-0 flex items-center sm:hidden">
          <!-- Mobile menu button-->
          <DisclosureButton class="relative inline-flex items-center justify-center rounded-md p-2 text-slate-300 hover:bg-slate-700 hover:text-white focus:ring-2 focus:ring-white focus:outline-hidden focus:ring-inset">
            <span class="absolute -inset-0.5" />
            <span class="sr-only">Open main menu</span>
            <Bars3Icon v-if="!open" class="block size-6" aria-hidden="true" />
            <XMarkIcon v-else class="block size-6" aria-hidden="true" />
          </DisclosureButton>
        </div>
        <div class="flex flex-1 items-center justify-center sm:items-stretch sm:justify-start">
          <div class="flex shrink-0 items-center text-slate-300">
            <img class="h-8 w-auto" src="#company_logo" alt="Logo" />
          </div>
          <div class="hidden sm:ml-6 sm:block">
            <div class="flex space-x-4">
              <router-link v-for="item in navigation" :key="item.name" :to="item.href" :class="[item.current ? 'bg-slate-900 text-white' : 'text-slate-300 hover:bg-slate-700 hover:text-white', 'rounded-md px-3 py-2 text-sm font-medium']" :aria-current="item.current ? 'page' : undefined">{{ item.name }}</router-link>
            </div>
          </div>
        </div>
        <div class="flex items-center justify-center sm:items-stretch sm:justify-start">
          <div class="hidden sm:ml-6 sm:block">
            <div class="flex space-x-4">
              <router-link to="/user/sign_in" append class="bg-slate-900 text-white hover:bg-slate-700 hover:text-slate-300 rounded-md px-3 py-2 text-sm font-medium" v-if="!currentUser">
                {{ $t('auth.signin') }}
              </router-link>
            </div>
          </div>
        </div>
        <div class="flex items-center justify-center sm:items-stretch sm:justify-start">
          <div class="hidden sm:ml-6 sm:block">
            <div class="flex space-x-4">
              <router-link to="/user/sign_up" class="bg-slate-900 text-white hover:bg-slate-700 hover:text-slate-300 rounded-md px-3 py-2 text-sm font-medium" v-if="!currentUser">
                {{ $t('auth.signup') }}
              </router-link>
            </div>
          </div>
        </div>
        <div v-if="currentUser" class="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0">
          <NavBarNotification />

          <!-- Profile dropdown -->
          <Menu as="div" class="relative ml-3">
            <div>
              <MenuButton class="relative flex rounded-full bg-slate-900 text-sm focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-slate-800 focus:outline-hidden">
                <span class="absolute -inset-1.5" />
                <span class="sr-only">Open user menu</span>
                <img class="size-8 rounded-full" src="/images/no-profile-picture.png" alt="" />
              </MenuButton>
            </div>
            <transition enter-active-class="transition ease-out duration-100" enter-from-class="transform opacity-0 scale-95" enter-to-class="transform opacity-100 scale-100" leave-active-class="transition ease-in duration-75" leave-from-class="transform opacity-100 scale-100" leave-to-class="transform opacity-0 scale-95">
              <MenuItems class="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-slate-800 py-1 shadow-lg ring-1 ring-black/5 focus:outline-hidden">
                <ThemeSwitcher />
                <MenuItem v-slot="{ active }">
                  <a href="#" :class="[active ? 'bg-slate-700 outline-hidden' : '', 'block px-4 py-2 text-sm text-slate-300']">1</a>
                </MenuItem>
                <MenuItem v-slot="{ active }">
                  <a href="#" :class="[active ? 'bg-slate-700 outline-hidden' : '', 'block px-4 py-2 text-sm text-slate-300']">2</a>
                </MenuItem>
                <MenuItem v-slot="{ active }">
                  <a href="#" :class="[active ? 'bg-slate-700 outline-hidden' : '', 'block px-4 py-2 text-sm text-slate-300']" @click.prevent="logOut">
                    {{ $t('auth.signout') }}
                  </a>
                </MenuItem>
              </MenuItems>
            </transition>
          </Menu>
        </div>
      </div>
    </div>

    <DisclosurePanel class="sm:hidden">
      <div class="space-y-1 px-2 pt-2 pb-3">
        <DisclosureButton v-for="item in navigation" :key="item.name" as="a" :href="item.href" :class="[item.current ? 'bg-slate-900 text-white' : 'text-slate-300 hover:bg-slate-700 hover:text-white', 'block rounded-md px-3 py-2 text-base font-medium']" :aria-current="item.current ? 'page' : undefined">{{ item.name }}</DisclosureButton>
      </div>
    </DisclosurePanel>
  </Disclosure>
</template>

<script>
  import { Disclosure, DisclosureButton, DisclosurePanel, Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/vue'
  import { Bars3Icon, XMarkIcon } from '@heroicons/vue/24/outline'
  import ThemeSwitcher  from './ThemeSwitcher.vue'
  import NavBarNotification  from './NavBarNotification.vue'

  export default {
    components: {
      Disclosure,
      DisclosureButton,
      DisclosurePanel,
      Menu,
      MenuButton,
      MenuItem,
      MenuItems,
      Bars3Icon,
      XMarkIcon,
      NavBarNotification,
      ThemeSwitcher,
    },
    props: {
      navbarMenuItems: {
        type: Array,
        default: []
      }
    },
    computed: {
      currentUser() {
        return this.$store.state.authentication.user;
      },
    },
    setup(props) {
      const navigation = [
        { name: 'Item1', href: '#', current: true },
        { name: 'Item2', href: '#', current: false },
        { name: 'Item3', href: '#', current: false },
        { name: 'Item4', href: '#', current: false },
      ]
      return { navigation }
    },
    methods: {
      setError (error, text) {
        this.error = (error.response && error.response.data && error.response.data.error) || text
      },
      logOut() {
        this.$store.dispatch('authentication/sign_out');
        this.$router.push('/user/sign_in');
      }
    }
  }
</script>