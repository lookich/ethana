import { createI18n } from 'vue-i18n'
import en from '../../../config/locales/en.yml'
import ru from '../../../config/locales/ru.yml'

const messages =  Object.assign({}, ru, en)

const i18n = createI18n({
  locale: 'ru',
  fallbackLocale: 'en',
  messages: messages,
})

export default i18n