require 'nokogiri'
require 'open-uri'

class V1Controller < ApplicationController
  def rule
    @doc = document
    retrieved_rule = get_rule(params[:number])
    render json: {rules: retrieved_rule}, status: :ok
  end

  def range
    @doc = document
    render json: {rules: get_range}, status: :ok
  end

  def glossary
    @doc = document
    render json: {}, status: :ok
  end

  def search
    @doc = document
    render json: {}, status: :ok
  end

  private
  def document
    Nokogiri::HTML(open(updated_local_file))
  end

  def get_range
    rules = []
    current_node = @doc.xpath("//*[@id='#{params[:number1].gsub(/-/, ".")}']").first.parent
    while true do
      text = current_node.css('p').first.text
      rules << {number: text[/^[\d\.]* - /][/^[\d\.]*/], contents: text.gsub(/^[\d\.]* - /, "")}
      break if text[/^[\d\.]* - /][/^[\d\.]*/] == params[:number2].gsub(/-/, ".")
      current_node = current_node.next.next
    end
    rules
  end

  def get_rule(number)
    rules = []
    case params[:number]
    when /\*$/
      nodes = @doc.xpath("//*[starts-with(@id, #{params[:number][/^[\d\-]*/].gsub(/-/, '.')})]")
      nodes.each do |node|
        text = node.parent.css('p').text
        rules << {number: text[/^[\d\.]* - /][/^[\d\.]*/], contents: text.gsub(/^[\d\.]* - /, "")}
      end
    else
      text = @doc.xpath("//*[@id='#{params[:number].gsub(/-/, ".")}']").first.parent.css('p').first.text
      rules << {number: text[/^[\d\.]* - /][/^[\d\.]*/], contents: text.gsub(/^[\d\.]* - /, "")}
    end
    rules
  end

  def updated_local_file # WILL NEED TO BE ALTERED TO STORE A LOCAL COPY
    "http://wftda.com/rules/all/#{params[:release]}"
  end
end
