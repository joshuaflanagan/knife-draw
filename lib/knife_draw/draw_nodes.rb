module KnifeDraw
  class DrawNodes < Chef::Knife
    deps do
      require 'graphviz'
    end

    banner "knife draw nodes [ENVIRONMENT]"

    def run
      environment = name_args.first if name_args.size > 0

      graph = ChefGraph.new cluster_environments: environment.nil?
      source = ChefServerSource.new

      source.nodes(environment).each do |name, node|
        node_box = graph.draw_node(name, node.chef_environment)
        ui.msg "name: #{name} env: #{node.chef_environment}"
        source.roles_for_node(node).each do |role_name|
          role_box = graph.draw_role(role_name)
          graph.connect(node_box, role_box)

          source.runlist_for_role(role_name).each do |run_list|
            runlist_box = graph.draw_runlist run_list.to_s
            graph.connect(role_box, runlist_box)
            ui.msg "\t\trunlist: #{run_list}"
          end
        end
      end
      graph.draw!
    end
  end

  class NodeDraw < DrawNodes
    banner "knife node draw [ENVIRONMENT]"
  end
end
