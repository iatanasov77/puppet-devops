require 'json'

def vault_keys_get
    json_string = File.read('/tmp/vault_init.json')
    
    JSON.parse(json_string)
end

Facter.add('vault_keys') do
  setcode do
    begin
      vault_keys_get
    rescue
      nil
    end
  end
end
