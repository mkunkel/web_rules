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
    @doc = glossary_doc
    render json: {}, status: :ok
  end

  def search
    @doc = document
    render json: {}, status: :ok
  end

  private
  def document
    updated_local_files
    Nokogiri::HTML(open(@local_rules))
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
      # binding.pry
      text = @doc.xpath("//*[@id='#{params[:number].gsub(/-/, ".")}']").first.parent.css('p').first.text
      rules << {number: text[/^[\d\.]* - /][/^[\d\.]*/], contents: text.gsub(/^[\d\.]* - /, "")}
    end
    rules
  end

  def glossary_doc
    updated_local_files
    Nokogiri::HTML(open(@local_glossary))
  end

  def recreate_existing_files
    FileUtils.rm(@local_rules) if File.exists?(@local_rules)
    FileUtils.rm(@local_glossary) if File.exists?(@local_glossary)
    FileUtils.touch(@local_rules)
    FileUtils.touch(@local_glossary)
  end

  def updated_local_files
    @local_rules = "#{Rails.root}/lib/assets/rules/#{params[:release]}_rules.html"
    @local_glossary = "#{Rails.root}/lib/assets/rules/#{params[:release]}_glossary.html"

    write_new_files
  end

  def write_new_files
    recreate_existing_files
    rules = File.open(@local_rules, 'w')
    glossary = File.open(@local_glossary, 'w')
    glossary_found = false
    open("http://wftda.com/rules/all/#{params[:release]}", 'r') do |file|
      file.each_line do |line|
        rules.puts line
        glossary.puts line if glossary_found
        if line.include?('<a id="10"')
          glossary_found = true
          glossary.puts "<html><body>"
        end
      end
    end
    rules.close
    glossary.close
  end
end
