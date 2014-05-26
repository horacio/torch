require 'coderay'
require 'imgkit'
require 'redcarpet'
require 'sinatra/base'

module Torch
  module Web
    class Output < Sinatra::Base
      get '/' do
        Torch.generate_snippet %q{
          class Greeting
            def hello
              puts 'opa'
            end
          end
        }
        send_file 'snippet.jpeg'
      end
    end
  end

  class Highlight < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, :ruby).div
    end
  end

  def self.generate_snippet(text)
    @@parser ||= configure_markdown_parser
    snippet = @@parser.render(text)
    persist_as_jpeg! snippet
  end

  def persist_as_jpeg!(snippet)
    image = IMGKit.new(snippet).to_img(:jpeg)
    File.write('snippet.jpeg', image)
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

  module_function :configure_markdown_parser, :persist_as_jpeg!
end
