module KnifeDraw
  class DrawNodes < Chef::Knife
    include VerboseOutput

    deps do
      require 'graphviz'
    end

    banner "knife draw nodes [FILENAME]"

    def run
      filename = name_args.size > 0 ? name_args.first : "output.png"
      environment = config[:environment]

      graph = ChefGraph.new cluster_environments: environment.nil?
      graph.add_formatter(ColorFormatter.new) if config[:color]

      source = ChefServerSource.new

      source.nodes(environment).each do |name, node|
        node_box = graph.draw_node(name, node.chef_environment)
        verbose_out "name: #{name} env: #{node.chef_environment}"
        source.roles_for_node(node).each do |role_name|
          verbose_out "\trole: #{role_name}"
          role_box = graph.draw_role(role_name)
          graph.connect(node_box, role_box)

          source.runlist_for_role(role_name).each do |run_list|
            runlist_box = graph.draw_runlist run_list.to_s
            graph.connect(role_box, runlist_box)
            verbose_out "\t\trunlist: #{run_list}"
          end
        end
      end
      graph.draw! filename
    end
  end

  class NodeDraw < DrawNodes
    banner "knife node draw"
  end
end
