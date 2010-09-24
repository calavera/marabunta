require 'murder'
require 'capistrano/recipes/deploy/strategy/murder'

module Capistrano
  module Recipes
    module Deploy
      module Strategy
        class Marabunta < Murder
          def upload(filename, remote_filename)
            super(filename, remote_filename)

            marabunta.deploy
          end
        end
      end
    end
  end
end
