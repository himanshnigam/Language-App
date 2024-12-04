class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  def welcome_email(user)
    @user = user
        locale = case @user.language
             when "english" then :en
             when "arabic" then :ar
             when "spanish" then :es
             when "hindi" then :hi
             when "french" then :fr
             else I18n.default_locale
             end
    
    I18n.with_locale(locale) do
      @greeting = I18n.t('user_mailer.welcome_email.greeting', name: @user.name)
      mail(
        to: @user.email,
        subject: I18n.t('user_mailer.welcome_email.subject')
      )
    end
  end

end
