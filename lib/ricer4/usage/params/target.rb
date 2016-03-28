#
# *user*#ch*an:serv
# Peter
# #foo
#
module ActiveRecord::Magic
  class Param::Target < Parameter
    
    def own_multi_handler?; true; end

    def default_options
      { online:nil, # online nil=both, true=only online, false=only offline
        wildcard:false, autocomplete:false, # wildcard handling
        current_server:false, current_channel:false, # only current
        users:false, channels:false, servers:false, # return these
        ambigous:false, null: true } # allow ambigious result? 
    end
    
    ##########
    ### In ###
    ##########
    def input_to_values(input)
      return wildcard_forbidden! if input.index('*') && (!options[:wildcard])
      input = input_prepare_for_wildcards(input)
      result = []
      result += input_to_servers(input) if options[:servers]
      result += input_to_channels(input) if options[:channels]
      result += input_to_users(input) if options[:users]
      return nil if result.length == 0
      options[:multiple] ? result : result.first
    end
    
    ###########
    ### Out ###
    ###########
    def value_to_input(value)
      return value.collect{|v|value_to_input(v)}.join(',') if value.is_a?(Array)
      return "#{value.name}:#{value.server.id}" if value.is_a?(Ricer4::User)
      return "#{value.name}:#{value.server.id}" if value.is_a?(Ricer4::Channel)
      return ":#{value.name}" if value.is_a?(Ricer4::Server)
    end
    
    ################
    ### Validate ###
    ################
    def validate!(targets)
      invalid!('ricer3.param.target.err_no_match') if Array(targets).length == 0
    end
    
    private
    
    ##################
    ### Exceptions ###
    ##################
    def wildcard_forbidden!
      invalid!(:err_no_wildcards)
    end
    
    def invalid_online_mode!
      invalid!(:err_invalid_online_option)
    end
    
    def input_prepare_for_wildcards(input)
      input.gsub!('*', '%')
      input.trim!('*') if options[:autocomplete]
      input
    end
    
    def input_to_users(input)
      input = input.substr_to('#')||input
      input = input.substr_to(':')||input
      input_to_results(Ricer4::User, nil, input)
    end

    def input_to_channels(input)
      # input = input.substr_from('#')||input unless input.start_with?('#')
      input = input.substr_to(':')||input
      input_to_results(Ricer4::Channel, :@channel_ids, input)
    end

    def input_to_servers(input)
      input = input.rsubstr_from(':')||input
      input_to_results(Ricer4::Server, :@server_ids, input)
    end
    
    def input_to_online_relation(relation)
      case options[:online]
      when true,false; relation.where(online:options[:online])
      when nil; relation
      else; invalid_online_mode!
      end
    end
    
    def input_to_results(relation, id_storage, input, autocomplete=0, results=[])
      relation = input_to_online_relation(relation)
      relation = relation.where("name LIKE ?", input)
      relation = relation.where("server_id IN ?", @server_ids) if (autocomplete == 0) && @server_ids && (@server_ids.length > 0)
      relation = relation.where("channel_id IN ?", @channel_ids) if (autocomplete == 0) && @channel_ids && (@channel_ids.length > 0)
      result = relation.all
      instance_variable_set(id_storage, result.collect{|r|r.id}) if id_storage
      results += result
      input_to_autocomplete(relation, id_storage, input, autocomplete, results)
    end
    
    def input_to_autocomplete(relation, id_storage, input, autocomplete, results)
      if options[:autocomplete]
        case autocomplete
        when 0; input_to_results(relation, id_storage, "#{input}%", 1, results)
        when 1; input_to_results(relation, id_storage, "%#{input}%", 2, results)
        end
      end
      results
    end
    
  end
end