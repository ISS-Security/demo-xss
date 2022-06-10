require 'sinatra'
require 'slim'

use Rack::Session::Cookie, secret: 'not-so-secret'
enable :logging

get '/' do
  slim :home
end

post '/' do
  conversation = session['board'] || ''
  session['board'] = '<br>' + params[:message] + '<br>' + conversation
  slim :home
end

get '/clear/?' do
  session['board'] = nil
  redirect '/'
end

## START Security Setup:
## - Comment out the rest of the file to disable protection
## - Uncomment rest of the file to enable protection

# # Uncomment to drop the login session in case of any violation
# use Rack::Protection, reaction: :drop_session # protects against CSRF (requires `disable :protection` before `use Rack::Session::...`)

# require 'secure_headers'
# use SecureHeaders::Middleware

# # Adjust settings below to see how it affects the page:
# # - config.csp: script_src, style_src, font-src (comment out to catch bootstrap scripts/styles/fonts)
# # - config.csp: style_src (add/remove 'unsafe-inline' to catch browser plugin CSS injections e.g., Pocket)
# SecureHeaders::Configuration.default do |config|
#   config.cookies = {
#     secure: true, # mark all cookies as "Secure"
#     httponly: true, # mark all cookies as "HttpOnly"
#     samesite: {
#       strict: true # mark all cookies as SameSite=Strict
#     }
#   }

#   config.x_frame_options = 'DENY' # Do not let this page be displayed in a frame
#   config.x_content_type_options = 'nosniff' # Do not let anyone change HTTPS
#   config.x_xss_protection = '1' # Block response if a script found in user input
#   config.x_permitted_cross_domain_policies = 'none' # Don't let others embed me
#   config.referrer_policy = 'origin-when-cross-origin' # Only report this site's hostname if user nagivates to other site

#   config.csp = {
#     # "meta" values: these keys will be inserted into header
#     report_only: false,     # false: disable unwanted features; true: report but don't disable
#     preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content

#     # directive values: these keys + values be inserted into header
#     default_src: %w['self'], # Use 'self' if a *_src configuration not defined
#     child_src: %w['self'], #
#     connect_src: %w[wws:], # valid sources for fetch, XMLHttpRequest, WebSocket, and EventSource connections
#     img_src: %w['self'],
#     font_src: %w['self' https://maxcdn.bootstrapcdn.com],
#     script_src: %w['self' https://code.jquery.com https://maxcdn.bootstrapcdn.com],
#     style_src: %w['self' 'unsafe-inline' https://maxcdn.bootstrapcdn.com],
#     form_action: %w['self'], # valid endpoints for form actions
#     frame_ancestors: %w['none'], # valid parents that may embed a page using the <frame> and <iframe> elements
#     object_src: %w['none'],
#     block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/

#     report_uri: %w[/report_csp_violation] # submit CSP violations by POST method
#   }
# end

# post '/report_csp_violation' do
#   logger.warn("CSP VIOLATION: #{request.body.read}")
# end
