module Ricer4::Plugins::Quote
  class Delete < Ricer4::Plugin

    trigger_is "quote.delete"

    permission_is :halfop

    has_usage '<id>'
    def execute(id)
      quote = Entity.find(id)
      quote.delete
      rply :msg_deleted, :id => quote.id
    end

  end
end
