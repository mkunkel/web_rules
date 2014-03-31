require 'nokogiri'
require 'open-uri'

class V1Controller < ApplicationController
  def rule
    retrieved_rule = get_rule(params[:number])
    render json: {rules: retrieved_rule}, status: :ok
  end

  def range
    render json: {}, status: :ok
  end

  def glossary
    render json: {}, status: :ok
  end

  def search
    render json: {}, status: :ok
  end

  private
  def document
    Nokogiri::HTML(open(updated_local_file))
  end

  def get_rule(number)
    doc = document
    rules = []
    case params[:number]
    when /\*$/
      nodes = doc.xpath("//*[starts-with(@id, #{params[:number][/^[\d\-]*/].gsub(/-/, '.')})]")
      nodes.each do |node|
        text = node.parent.css('p').text
        rules << {number: text[/^[\d\.]* - /][/^[\d\.]*/], contents: text.gsub(/^[\d\.]* - /, "")}
      end
    else
      text = doc.xpath("//*[@id='#{params[:number].gsub(/-/, ".")}']").first.parent.css('p').first.text
      rules << {number: text[/^[\d\.]* - /][/^[\d\.]*/], contents: text.gsub(/^[\d\.]* - /, "")}
    end
    rules
  end

  def updated_local_file # WILL NEED TO UP ALTERED TO STORE A LOCAL COPY
    "http://wftda.com/rules/all/#{params[:release]}"
  end
end
