require File.expand_path("../dmg_decimal/version", __FILE__)
require 'bigdecimal'

module Dmg
  class Decimal
    include Comparable
    attr_reader :pips, :options
    
    def precision
      @options[:precision]
    end
    
    def scale
      @options[:scale]
    end
    
    class << self
      alias pips new
      private :new
      
      def real(amount, options = {})
        pips(BigDecimal(amount.to_s) * 10 ** (options[:scale] || 2), options)
      end

      def zero
        @zero ||= pips 0
      end

      def one
        @one ||= pips 1
      end
    end
    
    # approximation: [round truncate ceil floor]
    def initialize(pips, options = {})
      @options = { :scale => 2,
                   :precision => 99,
                   :precision_approximation => :round,
                   :scale_approximation => :round,
                 }.update(options)

      pips = BigDecimal(pips.to_s).send(@options[:scale_approximation]).to_i
      
      current_precision = pips.abs.to_s.size
      desired_precision = @options[:precision]
      
      @pips = BigDecimal(pips.to_s).send(@options[:precision_approximation], desired_precision - current_precision).to_i
    end
    
    def rescale scale
      if scale == self.scale
        self
      else
        internal_scale = 10 ** scale
        self.class.pips(pips, @options.merge(scale: scale)).mul(internal_scale).div(self.internal_scale)
      end
    end
    
    def parse other
      case other
        when self.class then other
        else self.class.real(other, options)
      end
    end
    
    def zero?
      pips == 0
    end

    def +(other)
      other = parse(other)
      maxscale = [scale, other.scale].max
      
      this = rescale(maxscale)
      other = other.rescale(maxscale)
      
      self.class.pips this.pips + other.pips, @options.merge(:scale => maxscale)
    end
    
    def - other
      other = parse(other)
      maxscale = [scale, other.scale].max
      
      this = rescale(maxscale)
      other = other.rescale(maxscale)
      
      self.class.pips this.pips - other.pips, @options.merge(:scale => maxscale)
    end
    
    def -@
      self.class.zero - self
    end
    
    def * other
      case other
      when self.class
        raise 'bad state' unless options == other.options
        mul(other.pips)
      else from_pips(pips * other)
      end
    end
    
    def / other
      case other
      when self.class
        raise 'bad state' unless options == other.options
        div(other.pips)
      else from_pips(pips / other)
      end
    end
    
    def mul pips
      from_pips (self.pips * pips + internal_scale / 2) / internal_scale
    end
    
    def div pips
      a = self.pips * internal_scale
      b = pips
      
      c = a / b
      d = a % b
      
      from_pips c + (d * 2 >= b ? 1 : 0)
    end
    
    def <=> other
      pips * other.internal_scale <=> other.pips * internal_scale
    end
    
    def to_i
      pips / internal_scale
    end
    
    def to_f
      pips.to_f / internal_scale
    end
    
    def to_d desired_precision = self.precision
      BigDecimal(pips.to_s) / internal_scale
    end
    
    def to_s *args, &block
      to_d.to_s *args, &block
    end
    
    
  protected
    
    def internal_scale
      10 ** scale
    end
    
    def from_pips result
      self.class.pips(result, @options)
    end
  end
end