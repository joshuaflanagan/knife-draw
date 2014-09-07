require 'graphviz'

module KnifeDraw
  class ChefGraph
    attr_reader :graph

    def initialize(cluster_environments: false)
      @graph =  GraphViz.new(:KnifeDraw,
                             rankdir: :LR,
                             strict: true,
                             fontname: DefaultFormatter::FONT_NAME)
      @cluster_environments = cluster_environments
      @formatters = [DefaultFormatter.new]
    end

    def add_formatter(formatter)
      @formatters << formatter
    end

    def env_prefix
      @cluster_environments ? "cluster" : "env_"
    end

    def environments
      @environments ||= Hash.new {|hash, key|
        new_env = graph.add_graph("#{env_prefix}#{key}", label: key)
        @formatters.each{|f| f.environments(new_env)}
        hash[key] = new_env
      }
    end

    def draw_node(name, environment)
      node = environments[environment.to_s].add_nodes(name)
      @formatters.each{|f|
        f.all_shapes(node)
        f.nodes(node)
      }
      node
    end

    def draw_role(name)
      role = graph.add_nodes(name)
      @formatters.each{|f|
        f.all_shapes(role)
        f.roles(role)
      }
      role
    end

    def draw_runlist(name)
      runlist = graph.add_nodes(name)
      @formatters.each{|f|
        f.all_shapes(runlist)
        f.runlists(runlist)
      }
      runlist
    end

    def connect(source, target)
      edge = graph.add_edge(source, target)
      @formatters.each{|f| f.arrows(edge) }
      edge
    end

    def draw!(outputfile)
      filename=outputfile
      format = File.extname(filename)[1..-1] || :png
      graph.output format => filename
    end
  end
end
