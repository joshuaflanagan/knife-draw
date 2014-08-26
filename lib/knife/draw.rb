require "knife/draw/version"
require 'chef/knife'

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

  class DrawNodes < Chef::Knife
    deps do
      require 'graphviz'
    end

    banner "knife draw nodes [ENVIRONMENT]"

    def run
      environment = name_args.first if name_args.size > 0

      nodes_by_name = if environment
                        Chef::Node.list_by_environment environment, true
                      else
                        @env_boxes = true
                        Chef::Node.list true
                      end

      graph = ChefGraph.new

      nodes_by_name.each do |name, node|
        node_box = graph.draw_node(name, node.chef_environment)
        ui.msg "name: #{name} env: #{node.chef_environment}"
        node.roles.each do |role_name|
          role_box = graph.draw_role(role_name)
          graph.connect(node_box, role_box)

          role = Chef::Role.load(role_name)
          role.run_list.each do |run_list|
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

  class RoleDraw < DrawRoles
    banner "knife role draw"
  end

  class ChefGraph
    attr_reader :graph

    def initialize
      @graph =  GraphViz.new(:KnifeDraw, rankdir: :LR, strict: true)
    end

    def env_prefix
      @env_boxes ? "cluster" : "env_"
    end

    def environments
      @environments ||= Hash.new {|hash, key|
        hash[key] = graph.add_graph("#{env_prefix}#{key}", label: key)
      }
    end

    def draw_node(name, environment)
      environments[environment.to_s].add_nodes(name, shape: :box3d, color: :green, style: :bold)
    end

    def draw_role(name)
      graph.add_nodes(name, shape: :component, color: :blue)
    end

    def draw_runlist(name)
      graph.add_nodes(name, shape: :note, color: :grey)
    end

    def connect(source, target)
      graph.add_edge(source, target)
    end

    def draw!
      graph.output png: "output.png", dot: "output.dot"
    end
  end
end
