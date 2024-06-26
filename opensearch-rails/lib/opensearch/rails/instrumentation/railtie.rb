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
    module Instrumentation

      # Rails initializer class to require OpenSearch::Rails::Instrumentation files,
      # set up OpenSearch::Model and hook into ActionController to display OpenSearch-related duration
      #
      # @see http://edgeguides.rubyonrails.org/active_support_instrumentation.html
      #
      class Railtie < ::Rails::Railtie
        initializer "opensearch.instrumentation" do |app|
          require 'opensearch/rails/instrumentation/log_subscriber'
          require 'opensearch/rails/instrumentation/controller_runtime'

          OpenSearch::Model::Searching::SearchRequest.class_eval do
            include OpenSearch::Rails::Instrumentation::Publishers::SearchRequest
          end if defined?(OpenSearch::Model::Searching::SearchRequest)

          ActiveSupport.on_load(:action_controller) do
            include OpenSearch::Rails::Instrumentation::ControllerRuntime
          end
        end
      end

    end
  end
end
