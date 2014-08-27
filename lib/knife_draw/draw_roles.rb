module KnifeDraw
  class DrawRoles < Chef::Knife
    deps do
      require 'graphviz'
    end

    banner "knife draw roles [ENVIRONMENT]"

    def run
      environment = name_args.first if name_args.size > 0
      nodes_by_name = if environment
                        Chef::Node.list_by_environment environment, true
                      else
                        Chef::Node.list true
                      end
      nodes_by_name.each do |name, node|
        ui.msg "name: #{name} node: #{node}"
      end
    end
  end

  class RoleDraw < DrawRoles
    banner "knife role draw"
  end
end
