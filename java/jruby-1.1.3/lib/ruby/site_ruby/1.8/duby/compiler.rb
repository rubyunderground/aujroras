require 'duby'

module Duby
  module AST
    class Fixnum
      def compile(compiler)
        compiler.fixnum(literal)
      end
    end
    
    class String
      def compile(compiler)
        compiler.string(literal)
      end
    end
    
    class Float
      def compile(compiler)
        compiler.float(literal)
      end
    end
    
    class Boolean
      def compile(compiler)
        compiler.boolean(literal)
      end
    end
    
    class Body
      def compile(compiler)
        children.each {|child| child.compile(compiler)}
      end
    end
    
    class Local
      def compile(compiler)
        compiler.local(inferred_type, name)
      end
    end
    
    class LocalAssignment
      def compile(compiler)
        compiler.local_assign(inferred_type, name) {
          value.compile(compiler)
        }
      end
    end
    
    class Script
      def compile(compiler)
        body.compile(compiler)
      end
    end
    
    class MethodDefinition
      def compile(compiler)
        args_callback = proc {arguments.compile(compiler)}
        body_callback = proc {body.compile(compiler)}
        compiler.define_method(name, signature, args_callback, body_callback)
      end
    end
    
    class Arguments
      def compile(compiler)
        args.each {|arg| compiler.declare_argument(arg.name, arg.inferred_type)} if args
      end
    end
    
    class Noop
      def compile(compiler)
        # nothing
      end
    end
    
    class If
      def compile(compiler)
        cond_callback = proc { condition.compile(compiler) }
        body_callback = proc { body.compile(compiler) }
        else_callback = proc { self.else.compile(compiler)}
        
        compiler.branch(cond_callback, body_callback, else_callback)
      end
    end
    
    class Condition
      def compile(compiler)
        predicate.compile(compiler)
      end
    end
    
    class FunctionalCall
      def compile(compiler)
        args_callback = proc { parameters.each {|param| param.compile(compiler)}}
        
        compiler.self_call(name, args_callback)
      end
    end
    
    class Call
      def compile(compiler)
        recv_callback = proc { target.compile(compiler) }
        args_callback = proc { parameters.each {|param| param.compile(compiler)}}
        
        compiler.call(name, target.inferred_type, recv_callback, args_callback)
      end
    end
  end
end