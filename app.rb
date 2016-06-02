require 'sinatra'

use Rack::Session::Cookie, secret: 'not-so-secret'
enable :logging

get '/' do
  slim :home
end

post '/' do
  conversation = session['board'] || ''
  session['board'] = conversation + '<br>' + params[:message]
  slim :home
end

get '/clear/?' do
  session['board'] = nil
  redirect '/'
end

## START SecureHeaders Setup: Comment out the following to disable protection
require 'secure_headers'
use SecureHeaders::Middleware
## Choose between default (next line) and customized setup (see below)
# SecureHeaders::Configuration.default

## Adjust settings below to see how it affects the page:
## - config.csp: script_src, style_src, font-src (comment out to catch bootstrap scripts/styles/fonts)
## - config.csp: style_src (add/remove 'unsafe-inline' to catch browser plugin CSS injections e.g., Pocket)
SecureHeaders::Configuration.default do |config|
  config.cookies = {
    secure: true, # mark all cookies as "Secure"
    httponly: true, # mark all cookies as "HttpOnly"
    samesite: {
      strict: true # mark all cookies as SameSite=Strict
    }
  }
  config.x_frame_options = "DENY" # The page cannot be displayed in a frame, regardless of the site attempting to do so
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1" # instructs the user-agent to block the response in the event that script has been inserted from user input, instead of sanitizing
  config.x_download_options = "noopen" # user agent should not automatically open any downloads from this page
  config.x_permitted_cross_domain_policies = "none" # don’t allow content producers to embed your work in their content
  config.referrer_policy = "origin-when-cross-origin" # navigations to other sites will only send hostname as referral URL
  config.csp = {
    # "meta" values. these will shaped the header, but the values are not included in the header.
    report_only: false,     # false: actually disable unwanted features; true: report but don't disable
    preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.

    # directive values: these values will directly translate into source directives
    default_src: %w('self'),
    child_src: %w('self'),
    connect_src: %w(wws:), # valid sources for fetch, XMLHttpRequest, WebSocket, and EventSource connections
    img_src: %w('self'),
    font_src: %w('self' https://maxcdn.bootstrapcdn.com),
    script_src: %w('self' https://code.jquery.com https://maxcdn.bootstrapcdn.com),
    style_src: %w('self' https://maxcdn.bootstrapcdn.com 'unsafe-inline'),
    form_action: %w('self'), # valid endpoints for form actions
    frame_ancestors: %w('none'), # valid parents that may embed a page using the <frame> and <iframe> elements
    plugin_types: %w('none'),
    block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
    upgrade_insecure_requests: true, # see https://www.w3.org/TR/upgrade-insecure-requests/
    report_uri: %w(/report_csp_violation) # submit CSP violations by POST method
  }
end

post '/report_csp_violation' do
  logger.info("CSP VIOLATION: #{request.body.read}")
end
