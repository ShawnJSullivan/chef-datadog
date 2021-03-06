# Encoding: utf-8
require 'json_spec'
require 'serverspec'
require 'yaml'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

AGENT_CONFIG = '/etc/dd-agent/conf.d/tcp_check.yaml'

describe service('datadog-agent') do
  it { should be_running }
end

describe file(AGENT_CONFIG) do
  it { should be_a_file }

  it 'is valid yaml matching input values' do
    generated = YAML.load_file(AGENT_CONFIG)

    expected = {
      'instances' => [
        {
          'name' => 'test',
          'host' => 'localhost',
          'port' => 1234
        },
        {
          'name' => 'test2',
          'host' => 'localhost',
          'port' => 5678
        }
      ],
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
