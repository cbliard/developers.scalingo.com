require 'kramdown'
require 'nokogiri'
require 'pry'

Encoding.default_external = Encoding::UTF_8

def content_tag name, content, options = {}
  attributes = options.inject(""){|memo, (k,v)|
    memo << "#{k}='#{v}'"
    memo
  }
  "<#{name} #{attributes}>#{content}</#{name}>"
end

def doc_for(content)
  html = content
  Nokogiri::HTML::DocumentFragment.parse(html)
end

def toc_link(heading, output_filename)
  heading_id = heading[:id] || "#"
  content_tag(:a, heading.text, href: File.basename(output_filename) + "#" + heading_id)
end

def toc_item(heading, output_filename)
  content_tag(:li, toc_link(heading, output_filename))
end

def heading_nodes(content, element_type = 'h1')
  doc_for(content).css(element_type)
end

def table_of_contents(content, output_filename, tag = 'h2')
  list = heading_nodes(content, tag).map do |heading|
    toc_item(heading, output_filename)
  end.join
  content_tag(:ul, list, class: "list-unstyled")
end

def guess_layout(dir)
  if dir.end_with?("addon-provider-api")
    return "addon-provider-api"
  elsif dir.end_with?("one-click")
    return "one-click-api"
  elsif dir.end_with?("scalingo-json-schema")
    return "scalingo-json-schema"
  end
  return "default"
end

def build_directory(dir)
  row_identifier = "--- row ---"
  col_identifier = "||| col |||"

  row_begin_tag = "<div class='row'>"
  row_end_tag   = "</div>"
  sidebar_text_begin_tag = "<div class='col-xs-12 col-sm-6 sidebar-text'>"
  sidebar_text_end_tag   = "</div>"
  sidebar_code_begin_tag = "<div class='col-xs-12 col-sm-6 sidebar-code'>"
  sidebar_code_begin_tag_alt = "<div class='hidden-xs col-xs-12 col-sm-6 sidebar-code'>"
  sidebar_code_end_tag   = "</div>"

  kramdown_opts = {input: "GFM", syntax_highlighter: "rouge", hard_wrap: false}
  list_of_resources = {}

  files = File.join dir, "*"
  Dir.glob(files).sort.each{|input_filename|
    basename = input_filename.split("/")[1..-1].join("/").gsub(".md", "")
    if File.directory? input_filename
      FileUtils.mkdir_p basename
      FileUtils.mkdir_p File.join("_includes", basename)
      list_of_resources.merge! build_directory input_filename
      next
    end
    output_filename = basename + ".html"

    text = File.read(input_filename)

    ary_of_rows = text.split(row_identifier)

    ary_of_rows_transformed = ary_of_rows.map{|row|
      ary_of_cols = row.split(col_identifier)

      row_transformed = ""
      row_transformed << sidebar_text_begin_tag
      row_transformed << Kramdown::Document.new(ary_of_cols.first, kramdown_opts).to_html
      row_transformed << sidebar_text_end_tag

      if ary_of_cols.size == 1
        row_transformed << sidebar_code_begin_tag_alt
        row_transformed << sidebar_code_end_tag
      else
        row_transformed << sidebar_code_begin_tag
        row_transformed << Kramdown::Document.new(ary_of_cols.last, kramdown_opts).to_html
        row_transformed << sidebar_code_end_tag
      end

      row_transformed
    }

    text_transformed = row_begin_tag + ary_of_rows_transformed.join(row_end_tag + row_begin_tag) + row_end_tag

    File.open("_includes/#{basename}_toc.html", "w+") do |f|
      tag = basename == "index" ? 'h1' : 'h2'
      f.puts table_of_contents(text_transformed, output_filename, tag)
    end

    unless dir != "markdown" || basename == "index"
      resource_name = heading_nodes(text_transformed, 'h1').first.text
      list_of_resources[resource_name] = output_filename
    end

    File.open(output_filename, "w+") do |f|
      f.puts '---'
      f.puts "layout: #{ guess_layout(dir) }"
      f.puts "title: #{ resource_name }" if resource_name
      f.puts '---'
      f.puts ''
      f.puts text_transformed
    end
  }
  return list_of_resources
end

list_of_resources = build_directory "markdown"

File.open("_includes/list_of_resources.html", "w+") do |f|
  list_of_resources.each{|resource_name, output_filename|
    basename = File.basename output_filename, ".html"
    f.puts "<li class='resource'><a href='#{output_filename}'><strong>#{resource_name}</strong></a>{% if page.path == '#{output_filename}' %}{% include #{basename}_toc.html %}{% endif %}</li>"
  }
end
