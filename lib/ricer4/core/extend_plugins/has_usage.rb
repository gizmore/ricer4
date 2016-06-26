module Ricer4::Extend::HasUsage
  
  DEFAULT_HAS_USAGE_OPTIONS ||= {
    throws: false,
    trailing: false,
    function: :execute,
    parser_function: nil,
    permission: :public,
    scope: :everywhere,
  }
  
  def has_usage(pattern='', options={})
    class_eval{|klass|

      # Options
      options[:scope] = klass.get_class_variable(:@default_scope, :everywhere) unless options[:scope]
      options[:permission] = klass.get_class_variable(:@default_permission, :public) unless options[:permission]
      ActiveRecord::Magic::Options.merge(options, DEFAULT_HAS_USAGE_OPTIONS)
      
      # Sanity
      throw StandardError.new("#{klass.name} has_usage scope is not valid: #{options[:scope]}") unless scope = Ricer4::Scope.by_name(options[:scope])
      throw StandardError.new("#{klass.name} has_usage permission is not valid: #{options[:permission]}") unless permission = Ricer4::Permission.by_name(options[:permission])
      options[:scope], options[:permission] = scope, permission
    
      # Append precompiled param handlers as usage
      usages = klass.define_class_variable(:@usages, Ricer4::Usages.new)
      usages.add_pattern(pattern, options)

      # Register this once!
      klass.register_exec_function(:exec_has_usage) if usages.usages.length == 1

      def usages
        get_class_variable(:@usages)
      end
      
      def plugin_help
        get_usage
      end
      
      #########################
      ### Permission compat ###
      #########################
      def get_permission
        usages.get_least_permission(usages.in_scope)
      end
      
      def get_scope
        usages.get_combined_scope
      end
      
      #####################
      ### Exec Handlers ###
      #####################      
      private
      def exec_has_usage(line)
        #line = current_message.line.substr_from(' ').ltrim rescue ''
        exceptions = []
        wanted_scope = nil
        wanted_permission = nil
        self.usages.usages.each do |usage|
          begin
            if !usage.has_scope?
              wanted_scope = usage.get_scope
            elsif !usage.has_permission?
              wanted_permission = least_permission(usage.get_permission, wanted_permission)
            elsif args = usage.parse_args(self, line.dup)
              arm_publish('ricer/triggered', self)
              return usage.execute(self, args)
            end
          rescue ActiveRecord::Magic::InvalidParameter => e
            exceptions.unshift(e)
          rescue Ricer4::MissingParameterException => e
            exceptions.push(e)
          rescue StandardError => e
            return reply_exception(e)
          end
        end
        begin
          if (exceptions.length > 0) && (!line.empty?)
            ereply get_usage(:err_usage, exceptions.first.message)
          elsif (wanted_permission)
            ereply get_usage(:err_permission) + scope_and_permission_text
          elsif (wanted_scope)
            ereply get_usage(:err_scope) + scope_and_permission_text
          else
            ereply get_usage(:msg_usage)
          end
        rescue StandardError => e
          return reply_exception(e)
        end
      end

      def least_permission(a, b)
        return a if b.nil?
        a.bits < b.bits ? a : b
      end
      
      #####################
      ### Help Messages ###
      #####################
      def get_usage(key, error=nil)
        key ||= 'ricer4.extend.has_usage.' + key
        tt(key,
          error: error,
          trigger: plugin_trigger,
          description: plugin_description(error ? false : true),
          usage: display_usage_pattern,
          permissions: scope_and_permission_text,
        )
      end
      
      def display_usage_pattern
        ' '+I18n.t!("#{i18n_key}.usage") rescue usages.combined_pattern_text(usages.in_scope)
      end
      
      def scope_and_permission_text
        scope = usages.get_combined_scope
        permission = usages.get_least_permission(usages.usages)
        return "" if scope.everywhere? && permission.public?
        key = 'ricer4.extend.has_usage.usage_both'
        key = 'ricer4.extend.has_usage.usage_scope' if permission.public?
        key = 'ricer4.extend.has_usage.usage_permission' if scope.everywhere?
        scope_label = scope.to_usage_label
        scope_label = bold_text(scope_label) unless has_scope?
        perms_label = permission.to_usage_label
        perms_label = bold_text(perms_label) unless has_permission?
        return I18n.t(key, plugin_scope: scope_label, plugin_permission: perms_label)
      end
    }
    true
  end
end
