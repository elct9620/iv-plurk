# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

# Docker support
DOCKER_IMAGE_NAME = 'elct9620/iv-plurk'

namespace :docker do
  task :build do
    path = Pathname.new Bundler::GemHelper.new.build_gem
    path = path.relative_path_from Pathname.pwd
    version = Bundler::GemHelper.gemspec.version.to_s
    cmd = "docker build -t #{DOCKER_IMAGE_NAME} --build-arg GEM_PKG_PATH=#{path} ."
    sh(cmd)
    sh("docker tag #{DOCKER_IMAGE_NAME} #{DOCKER_IMAGE_NAME}:#{version}")
  end

  task release: [:build] do
    version = Bundler::GemHelper.gemspec.version.to_s
    cmd = "docker push #{DOCKER_IMAGE_NAME}"
    sh(cmd)
    sh("#{cmd}:#{version}")
  end
end
