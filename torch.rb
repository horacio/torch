require 'coderay'
require 'redcarpet'
require 'sinatra/base'

module Torch
  module Web
    class Output < Sinatra::Base
      get '/' do
        snippet = Torch.generate_snippet %q{
          ```ruby
          puts 'Hey, I am totally syntax highlighted!'
          ```
        }
      end
    end
  end

  def self.generate_snippet(text)
    @@parser ||= configure_markdown_parser
    @@parser.render(text)
  end

  def configure_markdown_parser
    renderer = Torch::Highlight.new(filter_html: true, hard_wrap: true)
    options = {
      fenced_code_block: true,
      no_intra_emphasis: true,
      autolink: true,
      superscript: true
    }
    @@parser = Redcarpet::Markdown.new(renderer, options)
  end

  class Highlight < Redcarpet::Render::HTML
    def block_code(code, language)
      result = CodeRay.scan(code, language)
      result.div
    end
  end

  module_function :configure_markdown_parser
end
