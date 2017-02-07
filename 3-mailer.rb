class ApplicationMailer  < ActionMailer::Base
  default from: %("MyApp" <notifications@myapp.com>)
  default template_path: -> (mailer) { "mailers/#{mailer.class.name.underscore}" }
  layout 'mailers'
end
