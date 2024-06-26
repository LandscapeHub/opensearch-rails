# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module OpenSearch
  module Rails
    module Lograge

      # Rails initializer class to require OpenSearch::Rails::Instrumentation files,
      # set up OpenSearch::Model and add Lograge configuration to display OpenSearch-related duration
      #
      # Require the component in your `application.rb` file and enable Lograge:
      #
      #     require 'opensearch/rails/lograge'
      #
      # You should see the full duration of the request to OpenSearch as part of each log event:
      #
      #     method=GET path=/search ... status=200 duration=380.89 view=99.64 db=0.00 es=279.37
      #
      # @see https://github.com/roidrage/lograge
      #
      class Railtie < ::Rails::Railtie
        initializer "opensearch.lograge" do |app|
          require 'opensearch/rails/instrumentation/publishers'
          require 'opensearch/rails/instrumentation/log_subscriber'
          require 'opensearch/rails/instrumentation/controller_runtime'

          OpenSearch::Model::Searching::SearchRequest.class_eval do
            include OpenSearch::Rails::Instrumentation::Publishers::SearchRequest
          end if defined?(OpenSearch::Model::Searching::SearchRequest)

          ActiveSupport.on_load(:action_controller) do
            include OpenSearch::Rails::Instrumentation::ControllerRuntime
          end

          config.lograge.custom_options = lambda do |event|
            { es: event.payload[:opensearch_runtime].to_f.round(2) }
          end
        end
      end

    end
  end
end
