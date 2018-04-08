require 'rack'
require 'json'

json_headers = { "Content-Type" => "application/json" }
text_headers = { "Content-Type" => "text/html" }

def info(env)
  env.select do |k,v|
    case k
    when "REQUEST_METHOD", "REQUEST_PATH", "QUERY_STRING", /^HTTP_.*/
      true
    else
      false
    end
  end.sort.reduce({}) do |memo,element|
    memo.merge(element.first => element.last)
  end
end

app = proc do |env|
  case env['REQUEST_PATH']
  when "/ping"
    [200, text_headers, ["PONG\n"]]
  when "/info"
    Thin::Logging.log_info "generating /info"
    Thin::Logging.log_info info(env)
    Thin::Logging.log_info JSON.generate(info(env))
    [200, json_headers, [JSON.generate(info(env))]]
  end
end

use Rack::CommonLogger

run app
