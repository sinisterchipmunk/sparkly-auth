# Sanity check to make sure generator views match the built-in views. I haven't figured out how to do this
# DRY-ly yet so this will remind me to copy changes to both locations.

require 'spec_helper'

describe 'the engine views' do
  it "should match generator views" do
    base = File.expand_path(File.join(File.dirname(__FILE__), "../app/"))
    Dir[File.join(base, "views/**/*")].each do |file|
      relative = file.sub(/^#{Regexp::escape base}/, '')
      generated_file = File.expand_path(File.join(File.dirname(__FILE__), "../generators/sparkly/templates", relative))
      raise "File #{generated_file} does not seem to exist" unless File.exist?(generated_file)
      if File.file?(file)
        raise "View #{relative} does not match generator version" unless File.read(file) == File.read(generated_file)
      end
    end
  end
end