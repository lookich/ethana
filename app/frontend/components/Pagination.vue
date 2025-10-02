<template>
  <div class="flex items-center justify-center bg-slate-100 dark:bg-slate-700 px-4 py-3 sm:px-6">
    <div class="sm:flex sm:flex-1 sm:items-center sm:justify-center">
      <div>
        <nav class="isolate inline-flex -space-x-px rounded-md shadow-xs" aria-label="Pagination">
          <a href="#" v-on:click="onClickFirstPage" :disabled="isInFirstPage" class="relative inline-flex items-center rounded-l-md px-2 py-2 bg-slate-600 text-white dark:bg-slate-300 dark:text-slate-900 ring-slate-300 ring-inset hover:bg-slate-500 dark:hover:bg-slate-500 focus:z-20 focus:outline-offset-0">
            <span class="sr-only">First</span>
            <ChevronDoubleLeftIcon class="size-5" aria-hidden="true" />
          </a>
          <a href="#" v-on:click="onClickPreviousPage" :disabled="isInFirstPage" class="relative inline-flex items-center px-2 py-2 bg-slate-600 text-white dark:bg-slate-300 dark:text-slate-900 ring-slate-300 ring-inset hover:bg-slate-500 dark:hover:bg-slate-500 focus:z-20 focus:outline-offset-0">
            <span class="sr-only">Previous</span>
            <ChevronLeftIcon class="size-5" aria-hidden="true" />
          </a>
          <div v-for="page in pages" :key="page.name" >
            <a href="#" v-on:click="onClickPage(page)" :disabled="page.isDisabled" :class="[page.name === currentPage ? 'z-10 bg-slate-800 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-slate-600' : 'bg-slate-300 text-slate-950 ring-inset ring-slate-300 hover:bg-slate-500 dark:hover:bg-slate-500 focus:outline-offset-0', 'relative inline-flex items-center px-4 py-2 text-sm font-semibold']">
              {{ page.name }}
            </a>
          </div>

          <a href="#" v-on:click="onClickNextPage" :disabled="isInLastPage" class="relative inline-flex items-center px-2 py-2 bg-slate-600 text-white dark:bg-slate-300 dark:text-slate-900 ring-slate-300 ring-inset hover:bg-slate-500 dark:hover:bg-slate-500 focus:z-20 focus:outline-offset-0">
            <span class="sr-only">Next</span>
            <ChevronRightIcon class="size-5" aria-hidden="true" />
          </a>
          <a href="#" v-on:click="onClickLastPage" :disabled="isInLastPage" class="relative inline-flex items-center rounded-r-md px-2 py-2 bg-slate-600 text-white dark:bg-slate-300 dark:text-slate-900 ring-slate-300 ring-inset hover:bg-slate-500 dark:hover:bg-slate-500 focus:z-20 focus:outline-offset-0">
            <span class="sr-only">Last</span>
            <ChevronDoubleRightIcon class="size-5" aria-hidden="true" />
          </a>
        </nav>
      </div>
    </div>
  </div>
</template>

<script>
  import { ChevronLeftIcon, ChevronRightIcon, ChevronDoubleLeftIcon, ChevronDoubleRightIcon } from '@heroicons/vue/24/outline'

  export default {
    name: 'Pagination',
    components: {
      ChevronLeftIcon,
      ChevronRightIcon,
      ChevronDoubleLeftIcon,
      ChevronDoubleRightIcon
    },
    mounted() {
    },
    computed: {
      startPage() {
        // When on the first page
        if (this.currentPage === 1) {
          return 1;
        }
        // When on the last page
        if (this.currentPage === this.totalPages) {
          const start = this.totalPages - this.maxVisibleButtons + 1;
          if (start <= 0) {
            return 1;
          } else {
            return start;
          }
        }
        // When inbetween
        return this.currentPage - 1;
      },
      pages() {
        const range = [];
        for (
          let i = this.startPage;
          i <= Math.min(this.startPage + this.maxVisibleButtons - 1, this.totalPages);
          i++
        ) {
          range.push({
            name: i,
            isDisabled: i === this.currentPage
          });
        }
        return range;
      },
      isInFirstPage() {
        return this.currentPage === 1;
      },
      isInLastPage() {
        return this.currentPage === this.totalPages;
      },
    },
    props: {
      maxVisibleButtons: {
        type: Number,
        required: false,
        default: 3
      },
      totalPages: {
        type: Number,
        required: true
      },
      perPage: {
        type: Number,
        required: true
      },
      currentPage: {
        type: Number,
        required: true
      }
    },
    methods: {
      onClickFirstPage() {
        this.$emit('pagechanged', 1);
      },
      onClickPreviousPage() {
        if (this.currentPage > 1) {
          this.$emit('pagechanged', this.currentPage - 1);
        }
      },
      onClickPage(page) {
        this.$emit('pagechanged', page.name);
        this.active = true
      },
      onClickNextPage() {
        if (this.currentPage < this.totalPages) {
          this.$emit('pagechanged', this.currentPage + 1);
        } else {
          this.$emit('pagechanged', this.currentPage);
        }
      },
      onClickLastPage() {
        this.$emit('pagechanged', this.totalPages);
      }
    }
  };
</script>
