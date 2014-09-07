require 'graphviz'

module KnifeDraw
  class ChefGraph
    attr_reader :graph

    NODE_COLOR = "#66c2a5"
    ROLE_COLOR = "#8da0cb"
    RUNLIST_COLOR = "#fc8d62"
    EDGE_COLOR = "gray52" #"#bebada"
    FONT_NAME = "Helvetica"

    def initialize(cluster_environments: false)
      @graph =  GraphViz.new(:KnifeDraw, rankdir: :LR, strict: true, fontname: FONT_NAME)
      @cluster_environments = cluster_environments
    end

    def env_prefix
      @cluster_environments ? "cluster" : "env_"
    end

    def environments
      @environments ||= Hash.new {|hash, key|
        hash[key] = graph.add_graph("#{env_prefix}#{key}", label: key, fontname: FONT_NAME)
      }
    end

    def draw_node(name, environment)
      environments[environment.to_s].add_nodes(name, shape: :box3d, fillcolor: NODE_COLOR, style: :filled, fontname: FONT_NAME)
    end

    def draw_role(name)
      graph.add_nodes(name, shape: :component, fillcolor: ROLE_COLOR, style: :filled, fontname: FONT_NAME)
    end

    def draw_runlist(name)
      graph.add_nodes(name, shape: :note, fillcolor: RUNLIST_COLOR, style: :filled, fontname: FONT_NAME)
    end

    def connect(source, target)
      graph.add_edge(source, target, color: EDGE_COLOR)
    end

    def draw!(outputfile)
      filename=outputfile
      format = File.extname(filename)[1..-1] || :png
      graph.output format => filename
    end
  end
end
