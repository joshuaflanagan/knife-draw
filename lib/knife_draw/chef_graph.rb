module KnifeDraw
  class ChefGraph
    attr_reader :graph

    def initialize(cluster_environments: false)
      @graph =  GraphViz.new(:KnifeDraw, rankdir: :LR, strict: true)
      @cluster_environments = cluster_environments
    end

    def env_prefix
      @cluster_environments ? "cluster" : "env_"
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
