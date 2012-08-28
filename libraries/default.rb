# Helper methods that should be available to all recipes.  These helper methods are scoped 
# to the node, where the methods that are in the cloud libraries are not.


# Get the proper system type.
def system_class
  virt = node.virtualization
  if virt[:role]
    if virt[:role] == "guest" && virt[:system] == "xen"
      return "xen-guest"
    elsif virt[:role] == "host" && virt[:system] == "xen"
      return "xen-host"
    else
      return  "unknown-vm"
    end
  else
    return "hardware"
  end
end

# Assert a system class against the nodes system class
def system_class?(arg)
  return true ? arg == system_class : false
end

# Arguments: nil
# Returns: Bool
# Description:  Check if this is a yum supported platform
def is_yum_platform
  case self.node[:platform]
  when "centos", "xenserver", "redhat"
    true
  else
    false
  end
end

# Get the domain name
def domain?
  return node.domain
end

# Get hostname
def hostname?
  return node.hostname
end

# Get macaddress
def mac?
  return node.macaddress
end

# Get cloud
def cloud?
  if node.attribute?('cloud')
    return node.cloud
  else
    nil
  end
end

# Get zone
def zone?
  if node.attribute?('zone')
    return node.zone
  else
    nil
  end
end

# Get pod
def pod?
  if node.attribute?('pod')
    return node.pod
  else
    nil
  end
end


