#--
# Copyright (c) 2004-2008 David Heinemeier Hansson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

begin
  require 'active_support'
rescue LoadError
  activesupport_path = "#{File.dirname(__FILE__)}/../../activesupport/lib"
  if File.directory?(activesupport_path)
    $:.unshift activesupport_path
    require 'active_support'
  end
end

$:.unshift "#{File.dirname(__FILE__)}/action_controller/vendor/html-scanner"

module ActionController
  # TODO: Review explicit to see if they will automatically be handled by
  # the initilizer if they are really needed.
  def self.load_all!
    [Base, CgiRequest, CgiResponse, RackRequest, RackRequest, Http::Headers, UrlRewriter, UrlWriter]
  end

  autoload :AbstractRequest, 'action_controller/request'
  autoload :AbstractResponse, 'action_controller/response'
  autoload :Base, 'action_controller/base'
  autoload :Benchmarking, 'action_controller/benchmarking'
  autoload :Caching, 'action_controller/caching'
  autoload :CgiRequest, 'action_controller/cgi_process'
  autoload :CgiResponse, 'action_controller/cgi_process'
  autoload :Cookies, 'action_controller/cookies'
  autoload :Dispatcher, 'action_controller/dispatcher'
  autoload :Filters, 'action_controller/filters'
  autoload :Flash, 'action_controller/flash'
  autoload :Helpers, 'action_controller/helpers'
  autoload :HttpAuthentication, 'action_controller/http_authentication'
  autoload :IntegrationTest, 'action_controller/integration'
  autoload :Layout, 'action_controller/layout'
  autoload :MimeResponds, 'action_controller/mime_responds'
  autoload :PolymorphicRoutes, 'action_controller/polymorphic_routes'
  autoload :RackRequest, 'action_controller/rack_process'
  autoload :RackResponse, 'action_controller/rack_process'
  autoload :RecordIdentifier, 'action_controller/record_identifier'
  autoload :RequestForgeryProtection, 'action_controller/request_forgery_protection'
  autoload :Rescue, 'action_controller/rescue'
  autoload :Resources, 'action_controller/resources'
  autoload :Routing, 'action_controller/routing'
  autoload :SessionManagement, 'action_controller/session_management'
  autoload :StatusCodes, 'action_controller/status_codes'
  autoload :Streaming, 'action_controller/streaming'
  autoload :TestCase, 'action_controller/test_case'
  autoload :TestProcess, 'action_controller/test_process'
  autoload :Translation, 'action_controller/translation'
  autoload :UrlRewriter, 'action_controller/url_rewriter'
  autoload :UrlWriter, 'action_controller/url_rewriter'
  autoload :Verification, 'action_controller/verification'

  module Http
    autoload :Headers, 'action_controller/headers'
  end
end

class CGI
  class Session
    autoload :ActiveRecordStore, 'action_controller/session/active_record_store'
    autoload :CookieStore, 'action_controller/session/cookie_store'
    autoload :DRbStore, 'action_controller/session/drb_store'
    autoload :MemCacheStore, 'action_controller/session/mem_cache_store'
  end
end

autoload :Mime, 'action_controller/mime_type'
autoload :Rack, 'action_controller/vendor/rack'

ActionController.load_all!
