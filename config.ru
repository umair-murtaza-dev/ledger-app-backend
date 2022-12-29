# require 'zipkin-tracer'
require_relative "config/environment"
# config = {
#   service_name: 'ledger',
#   service_port: 3000,
#   sample_rate: 1,
#   json_api_host: "https://zipkin.shared.dev..com",
#   log_tracing: true,
#   probability: 1
# }
# use ZipkinTracer::RackHandler, config
run Rails.application
