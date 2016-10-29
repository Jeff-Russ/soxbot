#!/usr/bin/env ruby

require 'fileutils'

class Params < String

  def initialize obj = []
    if   String === obj then from_s obj
    elsif Array === obj then from_a obj
    end
  end

  def to_a() return @arr end

  def from_a obj
    replace "\"#{obj.join("\" \"")}\""; @arr = obj
    self
  end

  def from_s obj
    replace "\"#{obj}\""; @arr = [ obj ]
    self
  end

  def [] key
      begin
        "\"#{@arr[key]}\""
      rescue
        puts "Key not found" 
        nil
      end
  end

  def []= key, val
      @arr.store key, val
      replace "\"#{@arr.join("\" \"")}\""
  end

  def << val
      @arr << val
      replace "\"#{@arr.join("\" \"")}\""
  end

  def each &block 
      @arr.eachv &block
      replace "\"#{@arr.join("\" \"")}\""
  end
end

