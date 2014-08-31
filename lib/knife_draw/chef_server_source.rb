module KnifeDraw
  class ChefServerSource
    def nodes(environment = nil)
      if environment
        Chef::Node.list_by_environment environment, true
      else
        Chef::Node.list true
      end
    end

    def roles
      Chef::Role.list true
    end

    def roles_for_node(node)
      node.roles
    end

    def runlist_for_role(role_name)
      role_details[role_name].run_list
    end

    private

    def role_details
      @role_details ||= Chef::Role.list(true)
    end
  end
end
