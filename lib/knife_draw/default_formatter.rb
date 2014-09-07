module KnifeDraw
  class DefaultFormatter
    FONT_NAME = "Helvetica"

    def all_shapes(shape)
      shape.fontname = FONT_NAME
    end

    def environments(environment)
    end

    def nodes(node)
      node.shape = :box3d
    end

    def roles(role)
      role.shape = :component
    end

    def runlists(runlist)
      runlist.shape = :note
    end

    def arrows(arrow)
    end
  end
end
