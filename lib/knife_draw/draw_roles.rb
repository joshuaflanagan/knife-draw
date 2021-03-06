module KnifeDraw
  class DrawRoles < Chef::Knife
    include VerboseOutput

    deps do
      require 'graphviz'
    end

    banner "knife draw roles [FILENAME]"

    def run
      filename = name_args.size > 0 ? name_args.first : "output.png"
      graph = ChefGraph.new
      graph.add_formatter(ColorFormatter.new) if config[:color]

      source = ChefServerSource.new
      source.roles.each do |role_name, role|
        verbose_out "name: #{role_name}"
        role_box = graph.draw_role(role_name)
        source.runlist_for_role(role_name).each do |run_list|
          runlist_box = graph.draw_runlist run_list.to_s
          graph.connect(role_box, runlist_box)
          verbose_out "\t\trunlist: #{run_list}"
        end
      end
      graph.draw! filename
    end
  end

  class RoleDraw < DrawRoles
    banner "knife role draw"
  end
end
