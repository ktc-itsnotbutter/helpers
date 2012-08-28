
module Helpers
  module Search

    # This performs a search on the chef server but restricts results
    # to only nodes that are also of the same scope. Where scope = env or domain
    # This should be used for all searches as it maximizes the isolation
    # of searches
    def scoped_search(scope, *args, &block)
      # extract the original query
      query = args[1] || "*:*"

      # prepend the environment to the query based on scope
      case scope
      when /domain/i,/dc/i
        args[1] = "domain:#{node[:domain]}  AND (#{query})"
      when /environment/, /env/i
        args[1] = "chef_environment:#{node[:chef_environment]} AND (#{query})"
      else
        rasie ArgumentError  "restricted search does not know how to handle scope: #{scope} "
      end

      # call the original search method
      search(*args, &block)
    end
    
    # simple method to rip off the number in a host
    #
    def get_hostnumber
      return  node[:hostname].scan(/(\d+\.?\d*$|\.\d+$)/).flatten[0].to_s
    end
  end
end

# this we want in recipe scope always
class Chef
  class Recipe
    include Helpers::Search
  end
end
