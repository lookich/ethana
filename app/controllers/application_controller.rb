class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  around_action :switch_locale

  def switch_locale(&action)
    locale = extract_locale_from_tld || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def extract_locale_from_tld
    parsed_locale = request.host.split(".").last
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
end
