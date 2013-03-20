# Yum Helpers Module
#
module Helpers
  module Repos
    # If we haven't set a server in attribs find one in this domain and use it.
    # Last resort use master repo
    # find the repo for wherever we are
    # result is cached per run with a builtin timeout unless told otherwise 
    def find_repo_servers(cached=true)
      # NOTE: might want to add in environment based server resolution as well
      repo_server = []
      if node.has_key? 'repo' and node[:repo].has_key? 'servers'
        repo_servers = node['repo']['servers'] 
      end

      node.run_state[:helper_cache] ||= Hash.new
      # return a cached result  
      if cached and  node.run_state[:helper_cache].has_key?(:repos) and :node.run_state[:helper_cache][:repos] != nil
        Chef::Log.debug "Repo Servers fetched from cache:  #{node.run_state[:helper_cache][:repos]}"
        repo_servers =  node.run_state[:helper_cache][:repos]  
      end

      if repo_servers.blank?
        # if we don't have a domain lets look for it in attribs
        # it really shouldn't ever be this way, but incase we want to handle 
        # the fail gracefully.
        domain = node['domain']
        if node['domain'].blank?
          # if dns attrib is empty then hardcode it to tld
          if node.has_key?("dns") and  node['dns'].has_key?(:domain)
            domain = node['dns']['domain']
          else
            Chef::Log.warn "No node attribute for 'Domain' detected. Can't continue"
          end
        end

        repo_servers = Array.new
        query = "domain:#{domain} AND recipes:mirror\\:\\:*"
        Chef::Log.info  "Running query #{query} for local repo servers"
        scoped_search("domain", :node, query).each do |new_node|
          if new_node.has_key?("fqdn") 
            repo_server = new_node.fqdn 
          else 
            repo_server = new_node.name + ".#{domain}"
          end
          Chef::Log.info "Found repo server: #{repo_server}" 
          repo_servers << repo_server
        end
        
        # store and sort 
        unless repo_servers.blank?
          repo_servers.sort! 
          Chef::Log.info "Caching search result #{repo_servers}"
        end
      end

      # if no servers found use fallback
      if repo_servers.blank?
        Chef::Log.info "No local repos servers found, falling back to defaults."
        if node.has_key? 'repo' and node[:repo].has_key? "fallback"
          repo_servers  = node['repo']['fallback']
        else
          Chef::Log.info "No Fallback servers found"
          return []
        end
        
      end

      node.run_state[:helper_cache][:repos] = repo_servers
      repo_servers
    end    


  end
end
