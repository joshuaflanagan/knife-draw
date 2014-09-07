module KnifeDraw
  class ColorFormatter
    DEFAULT_NODE_COLOR = "#66c2a5"
    DEFAULT_ROLE_COLOR = "#8da0cb"
    DEFAULT_RUNLIST_COLOR = "#fc8d62"
    DEFAULT_ARROW_COLOR = "gray52"

    attr_accessor :node_color, :role_color, :runlist_color, :arrow_color

    def initialize(options={})
      @node_color = options.fetch(:node_color, DEFAULT_NODE_COLOR)
      @role_color = options.fetch(:role_color, DEFAULT_ROLE_COLOR)
      @runlist_color = options.fetch(:runlist_color, DEFAULT_RUNLIST_COLOR)
      @arrow_color = options.fetch(:arrow_color, DEFAULT_ARROW_COLOR)
    end

    def all_shapes(shape)
    end

    def environments(environment)
    end

    def nodes(node)
      node.style = :filled
      node.fillcolor = node_color
    end

    def roles(role)
      role.style = :filled
      role.fillcolor = role_color
    end

    def runlists(runlist)
      runlist.style = :filled
      runlist.fillcolor = runlist_color
    end

    def arrows(arrow)
      arrow.color = arrow_color
    end
  end
end
