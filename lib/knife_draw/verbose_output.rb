module KnifeDraw
  module VerboseOutput
    def verbose_out(message)
      ui.msg(message) if config[:verbosity] >= 1
    end
  end
end
