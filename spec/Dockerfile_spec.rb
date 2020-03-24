require "serverspec"
require "docker"

describe "Dockerfile" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.')
    @image.tag(repo: 'masuda-teste', tag: 'latest')

    set :os, family: :alpine
    set :backend, :docker
    set :docker_image, @image.id
    set :docker_container_create_options, { 'Entrypoint' => ['ash']}
  end

  it "should have the maintainer label" do
    expect(@image.json["Config"]["Labels"].has_key?("maintainer"))
  end

  describe package('build-base') do
    it {should be_installed}
  end

  [
    'Gemfile',
    'Gemfile.lock',
  ].each do |f|
    describe file("/#{f}") do
      it { should exist }
    end
  end

  [
    'docker-api',
    'rspec',
    'rspec-expectations',
    'serverspec',
  ].each do |g|
    describe package(g) do
      it {should be_installed.by('gem')}
    end
  end
end
