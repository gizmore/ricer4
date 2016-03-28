module Ricer4
  class Usages
    
    attr_reader :usages
    
    def initialize
      @usages = []
    end
    
    def add_pattern(pattern, options)
      usage = Usage.new(pattern, options)
      @usages.push(usage)
    end
    
    def get_combined_scope
      @combined_scope ||= _get_combined_scope
    end
    def _get_combined_scope
      letters = ''
      usages.each do |usage|
        scope = usage.get_scope
        case scope.char
        when 'e'; return Ricer4::Scope::EVERYWHERE
        when 'c','u'; letters += scope.char unless letters.index(scope.char)
        end
      end
      _get_combined_scope_from_letters(letters)
    end
    def _get_combined_scope_from_letters(letters)
      case letters
      when 'c'; Ricer4::Scope::CHANNEL
      when 'u'; Ricer4::Scope::USER
      else; Ricer4::Scope::EVERYWHERE 
      end
    end
    
    def get_least_permission(usages)
      @least_permission ||= _get_least_permission(usages)
    end
    def _get_least_permission(usages)
      permission = nil
      usages.each do |usage|
        perm = usage.get_permission
        permission = perm if (perm.bits < permission.bits rescue true)
      end
      permission
    end
    
    def max_params(usages)
      max_params = 0
      usages.each do |usage|
        max_params = [usage.params.length, max_params].max
      end
      max_params
    end
    
    def in_scope
      @usages.select{|usage|usage.has_scope?}
    end
    
    ###############
    ### Display ###
    ###############
    def combined_pattern_text(usages)
      pattern_string = combined_pattern_text_columns(usages).join(' ')
      pattern_string = " #{pattern_string}" unless pattern_string.empty?
      pattern_string
    end
    ###
    ### Combine all usages in a single usage pattern, translated.
    ### We do it column wise for all usage patterns at once.
    ### Same param types are condensed as they don´t need to repeat. 
    ####
    ### Three different outcomes for a combined column N are possible:
    ### a) <server|channel>     - All patterns have column N mandatory (mA)
    ### b) [<server|channel>]   - All patterns have column N optional (oA)
    ### c) <server|[channel]>   - At least one pattern have column N of both (x1)
    ####
    ### Example:
    ### A) <server>   <channel>         <user>
    ### B) <server>   [<channel>]
    ### C) [<server>] <user>           [<page>]
    ###==> [<server>] <[channel]|user> [<user|page>]
    ####-
    ### TODO: Implement combined pattern output splitting on complex 
    ### But when there is a gap in the outcome between columns that hold at least 1 optional
    ### i.e. if there are frequent changes in the optional stream
    ### We should display multiple usages separated by \x02 OR \x02
    ###==> <server> <channel> [<user>]  OR  [<server>] <user> [<page>]
    ####---
    ### One can identify nasty usages and simply OR_append them after the easy ones have been condensed.
    #---------
    def combined_pattern_text_columns(usages)
      
      out = []

      # For column N
      for n in 0...max_params(usages)
        
        col = {} # all types for column N
        o1 = false # optional, at least one
        m1 = false # mandatory, at least one
        oA = false # optional, all
        
        # Gather the Nth column
        usages.each do |usage|
          if param = usage.param(n) # pattern has column? (yes)
            type = param.display_name
            if false # param.is_optional?
              col[type] = 1
              o1 = true # At least one optional
            else
              if col[type].nil? # Not an optional already? they take precendece.
                col[type] = 0
                m1 = true # At least one mandatory
              end
            end
          else # pattern has column? (no)
            oA = o1 = true # All optional, because one column does not have it at all
            m1 = false     # And none mandatory then
          end
        end
        
        x1 = o1 && m1 # Mixed flag

        # Push Nth column to out columns        
        if x1 # Mixed  <foo|[bar]>
          cout = []
          col.each do |label, optional|
            if optional; cout.push("[#{label}]")
            else; aout.push(label); end
          end
          out.push(cout.join('|'))
        elsif oA # All optional [<foo|bar>]
          out.push("[<#{col.keys.join('|')}>]")
        else     # All mandatory <foo|bar>
          out.push("<#{col.keys.join('|')}>")
        end
      end # .for i
      
      out
    end
    
    
  end
end
